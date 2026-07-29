import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/build_info.dart';
import 'google_identity_service.dart';

enum AuthAccessStatus {
  initializing,
  configurationRequired,
  signedOut,
  checking,
  authorizedOnline,
  authorizedOffline,
  disabled,
  offlineExpired,
  error,
}

class OfflineAccessPolicy {
  static const duration = Duration(days: 7);
  static const maximumClockSkew = Duration(minutes: 5);

  static bool allows({
    required String currentEmail,
    required String? savedEmail,
    required DateTime? lastVerifiedAt,
    required DateTime now,
  }) {
    if (savedEmail == null ||
        lastVerifiedAt == null ||
        currentEmail.toLowerCase() != savedEmail.toLowerCase()) {
      return false;
    }
    if (lastVerifiedAt.isAfter(now.add(maximumClockSkew))) return false;
    return now.isBefore(lastVerifiedAt.add(duration));
  }
}

class AuthAccessController extends ChangeNotifier {
  static const _lastVerifiedKey = 'lithica_auth_last_verified_at';
  static const _verifiedEmailKey = 'lithica_auth_verified_email';

  AuthAccessStatus status = AuthAccessStatus.initializing;
  String? email;
  String? uid;
  DateTime? lastVerifiedAt;
  String? message;
  final GoogleIdentityService _googleIdentity = GoogleIdentityService();

  bool get isAuthorized =>
      status == AuthAccessStatus.authorizedOnline ||
      status == AuthAccessStatus.authorizedOffline;

  bool get isOffline => status == AuthAccessStatus.authorizedOffline;

  Duration? get offlineRemaining {
    final verified = lastVerifiedAt;
    if (verified == null) return null;
    final remaining = verified
        .add(OfflineAccessPolicy.duration)
        .difference(DateTime.now().toUtc());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  Future<void> initialize() async {
    status = AuthAccessStatus.initializing;
    notifyListeners();
    try {
      final options = await _loadFirebaseOptions();
      if (options == null) {
        status = AuthAccessStatus.configurationRequired;
        message =
            'Completa assets/config/firebase_options.json para Android y Windows.';
        notifyListeners();
        return;
      }
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: options);
      }
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        status = AuthAccessStatus.signedOut;
        notifyListeners();
        return;
      }
      await _verifyUser(user);
    } catch (error) {
      status = AuthAccessStatus.error;
      message = 'No se pudo inicializar Firebase: $error';
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    if (!_googleIdentity.isConfigured) {
      status = AuthAccessStatus.configurationRequired;
      message = 'Falta configurar Google OAuth para esta plataforma.';
      notifyListeners();
      return;
    }
    await _authenticate(() async {
      final googleCredential = await _googleIdentity.signIn();
      if (googleCredential == null) {
        throw const GoogleSignInCancelled();
      }
      return FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(
          idToken: googleCredential.idToken,
          accessToken: googleCredential.accessToken,
        ),
      );
    });
  }

  Future<void> retryVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      status = AuthAccessStatus.signedOut;
      notifyListeners();
      return;
    }
    await _verifyUser(user);
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastVerifiedKey);
    await prefs.remove(_verifiedEmailKey);
    await _googleIdentity.signOut();
    await FirebaseAuth.instance.signOut();
    email = null;
    uid = null;
    lastVerifiedAt = null;
    message = null;
    status = AuthAccessStatus.signedOut;
    notifyListeners();
  }

  Future<void> _authenticate(
    Future<UserCredential> Function() operation,
  ) async {
    status = AuthAccessStatus.checking;
    message = null;
    notifyListeners();
    try {
      final credential = await operation();
      final user = credential.user;
      if (user == null || user.email == null) {
        throw StateError('Firebase no devolvió una identidad con correo.');
      }
      await _verifyUser(user);
    } on FirebaseAuthException catch (error) {
      status = AuthAccessStatus.signedOut;
      message = _authMessage(error.code);
      notifyListeners();
    } on GoogleSignInCancelled {
      status = AuthAccessStatus.signedOut;
      notifyListeners();
    } catch (error) {
      status = AuthAccessStatus.error;
      message = 'No se pudo autenticar: $error';
      notifyListeners();
    }
  }

  Future<void> _verifyUser(User user) async {
    status = AuthAccessStatus.checking;
    email = user.email!.trim().toLowerCase();
    uid = user.uid;
    message = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString(_verifiedEmailKey);
    final savedRaw = prefs.getString(_lastVerifiedKey);
    final savedAt = savedRaw == null ? null : DateTime.tryParse(savedRaw);
    lastVerifiedAt = savedAt;

    final ref = FirebaseFirestore.instance
        .collection('allowed_users')
        .doc(email);
    try {
      final snapshot = await ref.get(const GetOptions(source: Source.server));
      final now = DateTime.now().toUtc();
      if (!snapshot.exists) {
        await ref.set(_newUserPayload(user, now));
      } else {
        final data = snapshot.data() ?? <String, dynamic>{};
        if (data['enabled'] != true) {
          await prefs.remove(_lastVerifiedKey);
          await prefs.remove(_verifiedEmailKey);
          lastVerifiedAt = null;
          status = AuthAccessStatus.disabled;
          message = 'El acceso fue deshabilitado por el administrador.';
          notifyListeners();
          return;
        }
        await ref.update(_usagePayload(now));
      }
      await prefs.setString(_verifiedEmailKey, email!);
      await prefs.setString(_lastVerifiedKey, now.toIso8601String());
      lastVerifiedAt = now;
      status = AuthAccessStatus.authorizedOnline;
      notifyListeners();
    } on FirebaseException catch (error) {
      if (!_isConnectivityError(error.code)) {
        status = AuthAccessStatus.error;
        message = 'Firestore rechazó la verificación: ${error.message}';
        notifyListeners();
        return;
      }
      final allowed = OfflineAccessPolicy.allows(
        currentEmail: email!,
        savedEmail: savedEmail,
        lastVerifiedAt: savedAt,
        now: DateTime.now().toUtc(),
      );
      if (allowed) {
        status = AuthAccessStatus.authorizedOffline;
        message = 'Acceso offline temporal basado en la última verificación.';
      } else if (savedAt == null ||
          savedEmail?.toLowerCase() != email!.toLowerCase()) {
        status = AuthAccessStatus.error;
        message =
            'Se necesita conexión para completar la primera verificación.';
      } else {
        status = AuthAccessStatus.offlineExpired;
        message = 'Se requiere conexión: la verificación offline venció.';
      }
      notifyListeners();
    }
  }

  Map<String, dynamic> _newUserPayload(User user, DateTime now) => {
    'email': email,
    'uid': user.uid,
    'enabled': true,
    'role': 'tester',
    'createdAt': FieldValue.serverTimestamp(),
    ..._usagePayload(now),
  };

  Map<String, dynamic> _usagePayload(DateTime now) => {
    'appVersion': lithicaVersion,
    'buildNumber': int.tryParse(lithicaBuildNumber) ?? lithicaBuildNumber,
    'platform': _platformName,
    'lastSeenAt': FieldValue.serverTimestamp(),
    'sessionCount': FieldValue.increment(1),
    'activeDay': now.toIso8601String().substring(0, 10),
  };

  Future<FirebaseOptions?> _loadFirebaseOptions() async {
    if (kIsWeb) return null;
    final platformKey = switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.windows => 'windows',
      _ => null,
    };
    if (platformKey == null) return null;
    final raw = await rootBundle.loadString(
      'assets/config/firebase_options.json',
    );
    final root = jsonDecode(raw) as Map<String, dynamic>;
    final values = root[platformKey] as Map<String, dynamic>?;
    if (values == null) return null;
    final required = ['apiKey', 'appId', 'messagingSenderId', 'projectId'];
    if (required.any((key) => '${values[key] ?? ''}'.trim().isEmpty)) {
      return null;
    }
    return FirebaseOptions(
      apiKey: values['apiKey'] as String,
      appId: values['appId'] as String,
      messagingSenderId: values['messagingSenderId'] as String,
      projectId: values['projectId'] as String,
      authDomain: _nullable(values['authDomain']),
      storageBucket: _nullable(values['storageBucket']),
    );
  }

  String? _nullable(Object? value) {
    final text = '${value ?? ''}'.trim();
    return text.isEmpty ? null : text;
  }

  String get _platformName => switch (defaultTargetPlatform) {
    TargetPlatform.android => 'android',
    TargetPlatform.windows => 'windows',
    _ => defaultTargetPlatform.name,
  };

  bool _isConnectivityError(String code) => const {
    'aborted',
    'cancelled',
    'deadline-exceeded',
    'network-request-failed',
    'unavailable',
    'unknown',
  }.contains(code);

  String _authMessage(String code) => switch (code) {
    'account-exists-with-different-credential' =>
      'Ese correo ya usa otro método de acceso.',
    'invalid-credential' => 'Google no devolvió una credencial válida.',
    'network-request-failed' => 'No hay conexión para autenticar.',
    'operation-not-allowed' =>
      'Activa el proveedor Google en Firebase Authentication.',
    _ => 'Firebase Auth rechazó el ingreso: $code',
  };
}

class GoogleSignInCancelled implements Exception {
  const GoogleSignInCancelled();
}
