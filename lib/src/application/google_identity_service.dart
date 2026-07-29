import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleIdentityCredential {
  const GoogleIdentityCredential({required this.idToken, this.accessToken});

  final String idToken;
  final String? accessToken;
}

class GoogleIdentityService {
  GoogleIdentityService()
    : _androidSignIn = GoogleSignIn(scopes: const ['email', 'profile']);

  static const _compiledDesktopClientId = String.fromEnvironment(
    'LITHICA_GOOGLE_DESKTOP_CLIENT_ID',
  );
  static const _compiledDesktopClientSecret = String.fromEnvironment(
    'LITHICA_GOOGLE_DESKTOP_CLIENT_SECRET',
  );

  final GoogleSignIn _androidSignIn;

  String get _desktopClientId =>
      Platform.environment['LITHICA_GOOGLE_DESKTOP_CLIENT_ID'] ??
      _compiledDesktopClientId;

  String get _desktopClientSecret =>
      Platform.environment['LITHICA_GOOGLE_DESKTOP_CLIENT_SECRET'] ??
      _compiledDesktopClientSecret;

  bool get isConfigured =>
      Platform.isAndroid ||
      (Platform.isWindows && _desktopClientId.trim().isNotEmpty);

  Future<GoogleIdentityCredential?> signIn() async {
    if (Platform.isAndroid) {
      final account = await _androidSignIn.signIn();
      if (account == null) return null;
      final authentication = await account.authentication;
      final idToken = authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw StateError('Google no devolvió una identidad válida.');
      }
      return GoogleIdentityCredential(
        idToken: idToken,
        accessToken: authentication.accessToken,
      );
    }
    if (!Platform.isWindows || _desktopClientId.trim().isEmpty) {
      throw StateError('Falta configurar Google OAuth para Windows.');
    }
    return _signInOnWindows();
  }

  Future<GoogleIdentityCredential> _signInOnWindows() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final redirectUri = 'http://127.0.0.1:${server.port}/oauth2redirect';
    final verifier = _randomToken(64);
    final challenge = base64Url
        .encode(sha256.convert(utf8.encode(verifier)).bytes)
        .replaceAll('=', '');
    final state = _randomToken(32);
    final authorizationUri =
        Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
          'client_id': _desktopClientId,
          'redirect_uri': redirectUri,
          'response_type': 'code',
          'scope': 'openid email profile',
          'code_challenge': challenge,
          'code_challenge_method': 'S256',
          'state': state,
          'prompt': 'select_account',
        });

    await Process.start('rundll32.exe', [
      'url.dll,FileProtocolHandler',
      authorizationUri.toString(),
    ], mode: ProcessStartMode.detached);

    try {
      final request = await server.first.timeout(const Duration(minutes: 3));
      final returnedState = request.uri.queryParameters['state'];
      final code = request.uri.queryParameters['code'];
      final error = request.uri.queryParameters['error'];
      request.response.headers.contentType = ContentType.html;
      request.response.write(
        '<!doctype html><html><body style="font-family:sans-serif">'
        '<h2>Lithica GeoTech</h2>'
        '<p>Puede cerrar esta ventana y volver a la aplicación.</p>'
        '</body></html>',
      );
      await request.response.close();
      if (error != null) throw StateError('Google rechazó el acceso: $error');
      if (returnedState != state || code == null || code.isEmpty) {
        throw StateError('La respuesta de Google no es válida.');
      }
      return _exchangeCode(
        code: code,
        verifier: verifier,
        redirectUri: redirectUri,
      );
    } finally {
      await server.close(force: true);
    }
  }

  Future<GoogleIdentityCredential> _exchangeCode({
    required String code,
    required String verifier,
    required String redirectUri,
  }) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(
        Uri.https('oauth2.googleapis.com', '/token'),
      );
      request.headers.contentType = ContentType(
        'application',
        'x-www-form-urlencoded',
        charset: 'utf-8',
      );
      final fields = <String, String>{
        'client_id': _desktopClientId,
        if (_desktopClientSecret.isNotEmpty)
          'client_secret': _desktopClientSecret,
        'code': code,
        'code_verifier': verifier,
        'redirect_uri': redirectUri,
        'grant_type': 'authorization_code',
      };
      request.write(
        fields.entries
            .map(
              (entry) =>
                  '${Uri.encodeQueryComponent(entry.key)}='
                  '${Uri.encodeQueryComponent(entry.value)}',
            )
            .join('&'),
      );
      final response = await request.close();
      final body = await utf8.decoder.bind(response).join();
      final decoded = jsonDecode(body);
      if (response.statusCode != HttpStatus.ok || decoded is! Map) {
        throw StateError('Google no pudo completar el acceso.');
      }
      final idToken = decoded['id_token']?.toString();
      if (idToken == null || idToken.isEmpty) {
        throw StateError('Google no devolvió una identidad.');
      }
      return GoogleIdentityCredential(
        idToken: idToken,
        accessToken: decoded['access_token']?.toString(),
      );
    } finally {
      client.close(force: true);
    }
  }

  String _randomToken(int byteCount) {
    final random = Random.secure();
    final bytes = List<int>.generate(byteCount, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  Future<void> signOut() async {
    if (Platform.isAndroid) await _androidSignIn.signOut();
  }
}
