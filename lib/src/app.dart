import 'dart:async';
import 'package:flutter/material.dart';
import 'application/auth_access_controller.dart';
import 'application/geotech_controller.dart';
import 'presentation/auth_gate.dart';
import 'presentation/geotech_home_page.dart';
import 'theme/lithica_theme.dart';
import 'widgets/lithica_background.dart';

class LithicaGeoTechApp extends StatefulWidget {
  const LithicaGeoTechApp({super.key});

  @override
  State<LithicaGeoTechApp> createState() => _LithicaGeoTechAppState();
}

class _LithicaGeoTechAppState extends State<LithicaGeoTechApp> {
  final GeotechController _controller = GeotechController();
  final AuthAccessController _authController = AuthAccessController();
  Timer? _splashTimer;
  bool _showLaunchSplash = true;

  @override
  void initState() {
    super.initState();
    unawaited(_authController.initialize());
    _splashTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _showLaunchSplash = false);
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _authController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(_controller.guiScale)),
          child: MaterialApp(
            title:
                'Lithica GeoTech - Base de Conocimiento Geotécnica Versionada',
            debugShowCheckedModeBanner: false,
            themeMode: _controller.themeMode,
            darkTheme: buildLithicaTheme(Brightness.dark),
            theme: buildLithicaTheme(Brightness.light),
            home: AnimatedSwitcher(
              duration: const Duration(milliseconds: 900),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: _showLaunchSplash
                  ? const _LaunchSplashPage(key: ValueKey('launch-splash'))
                  : AuthGate(
                      controller: _authController,
                      child: GeotechHomePage(
                        controller: _controller,
                        authController: _authController,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _LaunchSplashPage extends StatefulWidget {
  const _LaunchSplashPage({super.key});

  @override
  State<_LaunchSplashPage> createState() => _LaunchSplashPageState();
}

class _LaunchSplashPageState extends State<_LaunchSplashPage> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) => LithicaBackground(
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          opacity: _visible ? 1 : 0,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 430),
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.fromLTRB(30, 28, 30, 24),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 34,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/branding/logo_complete.png', height: 128),
                const SizedBox(height: 18),
                Text(
                  'Conectando conocimiento geotécnico',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                const LinearProgressIndicator(minHeight: 5),
                const SizedBox(height: 16),
                const Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 18,
                  children: [
                    Icon(Icons.groups_2_outlined, size: 19),
                    Icon(Icons.hub_outlined, size: 19),
                    Icon(Icons.menu_book_outlined, size: 19),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
