import 'package:flutter/material.dart';

import '../application/auth_access_controller.dart';
import '../theme/lithica_theme.dart';
import '../widgets/lithica_background.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.controller, required this.child});

  final AuthAccessController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.isAuthorized) return child;
        return switch (controller.status) {
          AuthAccessStatus.initializing ||
          AuthAccessStatus.checking => const _AuthMessage(
            icon: Icons.sync,
            title: 'Verificando identidad',
            message: 'Consultando Firebase Auth y Firestore…',
            loading: true,
          ),
          AuthAccessStatus.configurationRequired => _AuthMessage(
            icon: Icons.cloud_off,
            title: 'Firebase pendiente de configurar',
            message: controller.message ?? '',
            actionLabel: 'Reintentar',
            onAction: controller.initialize,
          ),
          AuthAccessStatus.signedOut => _LoginPanel(controller: controller),
          AuthAccessStatus.disabled => _AuthMessage(
            icon: Icons.block,
            title: 'Acceso deshabilitado',
            message: controller.message ?? '',
            actionLabel: 'Cerrar sesión',
            onAction: controller.signOut,
          ),
          AuthAccessStatus.offlineExpired => _AuthMessage(
            icon: Icons.wifi_off,
            title: 'Verificación vencida',
            message: controller.message ?? '',
            actionLabel: 'Verificar con conexión',
            onAction: controller.retryVerification,
            secondaryLabel: 'Cerrar sesión',
            onSecondary: controller.signOut,
          ),
          AuthAccessStatus.error => _AuthMessage(
            icon: Icons.error_outline,
            title: 'No se pudo validar el acceso',
            message: controller.message ?? '',
            actionLabel: 'Reintentar',
            onAction: controller.retryVerification,
            secondaryLabel: 'Cerrar sesión',
            onSecondary: controller.signOut,
          ),
          AuthAccessStatus.authorizedOnline ||
          AuthAccessStatus.authorizedOffline => child,
        };
      },
    );
  }
}

class _LoginPanel extends StatelessWidget {
  const _LoginPanel({required this.controller});
  final AuthAccessController controller;

  @override
  Widget build(BuildContext context) {
    return _AuthShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('assets/branding/logo.jpg', height: 96),
          const SizedBox(height: 16),
          const Text(
            'Identificación Lithica GeoTech',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Se necesita iniciar sesión con una cuenta de Google.',
            textAlign: TextAlign.center,
          ),
          if (controller.message != null) ...[
            const SizedBox(height: 10),
            Text(
              controller.message!,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ],
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: controller.signInWithGoogle,
            icon: const Icon(Icons.account_circle_outlined),
            label: const Text('Ingresar con Google'),
          ),
        ],
      ),
    );
  }
}

class _AuthMessage extends StatelessWidget {
  const _AuthMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.loading = false,
    this.actionLabel,
    this.onAction,
    this.secondaryLabel,
    this.onSecondary,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool loading;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return _AuthShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: LithicaColors.logoGreen),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          if (loading) ...[
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
          if (actionLabel != null) ...[
            const SizedBox(height: 20),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
          if (secondaryLabel != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
          ],
        ],
      ),
    );
  }
}

class _AuthShell extends StatelessWidget {
  const _AuthShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LithicaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
