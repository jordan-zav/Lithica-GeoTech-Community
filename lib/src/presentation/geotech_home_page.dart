import 'package:flutter/material.dart';
import '../application/auth_access_controller.dart';
import '../application/geotech_controller.dart';
import '../theme/lithica_theme.dart';
import '../widgets/lithica_background.dart';
import 'geotech_settings_dialog.dart';
import 'hoek_brown_page.dart';
import 'isrm_page.dart';
import 'kb_page.dart';
import 'q_system_page.dart';
import 'rmr_page.dart';

class GeotechHomePage extends StatefulWidget {
  const GeotechHomePage({super.key, this.controller, this.authController});

  final GeotechController? controller;
  final AuthAccessController? authController;

  @override
  State<GeotechHomePage> createState() => _GeotechHomePageState();
}

class _GeotechHomePageState extends State<GeotechHomePage> {
  int _activeTabIndex = 0;
  late final GeotechController _fallbackController;

  GeotechController get _activeController =>
      widget.controller ?? _fallbackController;

  bool get _isExpertMode => _activeController.expertMode;

  @override
  void initState() {
    super.initState();
    _fallbackController = GeotechController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _fallbackController.dispose();
    }
    super.dispose();
  }

  void _setExpertMode(bool enabled) {
    _activeController.setExpertMode(enabled);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeController = _activeController;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: LithicaBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 850;

              if (isWide) {
                return Row(
                  children: [
                    _buildSidebar(context, isDark, activeController),
                    Expanded(
                      child: IndexedStack(
                        index: _activeTabIndex,
                        children: [
                          KBPage(isExpertMode: _isExpertMode),
                          RMRPage(isExpertMode: _isExpertMode),
                          QSystemPage(isExpertMode: _isExpertMode),
                          HoekBrownPage(isExpertMode: _isExpertMode),
                          ISRMPage(isExpertMode: _isExpertMode),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildTopCompactHeader(context, isDark, activeController),
                    Expanded(
                      child: IndexedStack(
                        index: _activeTabIndex,
                        children: [
                          KBPage(isExpertMode: _isExpertMode),
                          RMRPage(isExpertMode: _isExpertMode),
                          QSystemPage(isExpertMode: _isExpertMode),
                          HoekBrownPage(isExpertMode: _isExpertMode),
                          ISRMPage(isExpertMode: _isExpertMode),
                        ],
                      ),
                    ),
                    _buildBottomNav(context, isDark),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // Left Sidebar for Horizontal / Wide Mode
  Widget _buildSidebar(
    BuildContext context,
    bool isDark,
    GeotechController activeController,
  ) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xF2102A43) : const Color(0xFAFFFFFF),
        border: Border(
          right: BorderSide(
            color: LithicaColors.logoTeal.withValues(
              alpha: isDark ? 0.3 : 0.15,
            ),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? LithicaColors.logoNavyDeep
                      : LithicaColors.logoGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: LithicaColors.logoGreen),
                ),
                child: Image.asset(
                  'assets/branding/logo.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : LithicaColors.logoNavyDeep,
                        ),
                        children: const [
                          TextSpan(text: "Lithica "),
                          TextSpan(
                            text: "GeoTech",
                            style: TextStyle(color: LithicaColors.logoGreen),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "KB v1.0 — Base Geotécnica",
                      style: TextStyle(
                        color: isDark
                            ? LithicaColors.logoLime
                            : const Color(0xFF2B6615),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: LithicaColors.logoTeal.withValues(alpha: 0.2)),
          const SizedBox(height: 12),

          // Vertical Navigation List
          _buildSidebarNavItem(
            0,
            "Base de Conocimiento",
            Icons.menu_book,
            isDark,
          ),
          const SizedBox(height: 6),
          _buildSidebarNavItem(1, "RMR Bieniawski", Icons.grid_view, isDark),
          const SizedBox(height: 6),
          _buildSidebarNavItem(2, "Q-System Barton", Icons.analytics, isDark),
          const SizedBox(height: 6),
          _buildSidebarNavItem(3, "Hoek-Brown & GSI", Icons.show_chart, isDark),
          const SizedBox(height: 6),
          _buildSidebarNavItem(4, "Estándares ISRM", Icons.verified, isDark),

          const Spacer(),
          Divider(color: LithicaColors.logoTeal.withValues(alpha: 0.2)),
          const SizedBox(height: 12),

          // Mode Toggle Switcher
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B2238) : const Color(0xFFF0F2EF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: LithicaColors.logoTeal.withValues(
                  alpha: isDark ? 0.3 : 0.2,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ingeniero",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: !_isExpertMode
                        ? (isDark
                              ? LithicaColors.logoLime
                              : const Color(0xFF2B6615))
                        : (isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF64748B)),
                  ),
                ),
                Switch(
                  value: _isExpertMode,
                  activeTrackColor: LithicaColors.alterationPurple,
                  onChanged: _setExpertMode,
                ),
                Text(
                  "Experto",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _isExpertMode
                        ? LithicaColors.alterationPurple
                        : (isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Settings Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => GeotechSettingsDialog(
                  controller: activeController,
                  authController: widget.authController,
                ),
              ),
              icon: const Icon(Icons.tune_rounded, size: 18),
              label: const Text(
                "Configuraciones",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarNavItem(
    int index,
    String title,
    IconData icon,
    bool isDark,
  ) {
    final isSel = _activeTabIndex == index;
    final activeText = isDark
        ? LithicaColors.logoLime
        : const Color(0xFF2B6615);
    final inactiveText = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF64748B);

    return InkWell(
      onTap: () => setState(() => _activeTabIndex = index),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSel
              ? (isDark ? const Color(0xFF163247) : const Color(0xFFEEF3EA))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSel
                ? (isDark
                      ? LithicaColors.logoLime.withValues(alpha: 0.35)
                      : LithicaColors.logoGreen.withValues(alpha: 0.35))
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 3,
              height: 16,
              decoration: BoxDecoration(
                color: isSel ? activeText : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, size: 18, color: isSel ? activeText : inactiveText),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                  color: isSel ? activeText : inactiveText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Top Compact Header for Vertical / Narrow Mode
  Widget _buildTopCompactHeader(
    BuildContext context,
    bool isDark,
    GeotechController activeController,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xF2102A43) : const Color(0xFAFFFFFF),
        border: Border(
          bottom: BorderSide(
            color: LithicaColors.logoTeal.withValues(
              alpha: isDark ? 0.3 : 0.15,
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/branding/logo.png',
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Text(
                "Lithica GeoTech",
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : LithicaColors.logoNavyDeep,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    "Ing",
                    style: TextStyle(
                      fontSize: 10,
                      color: !_isExpertMode
                          ? LithicaColors.logoLime
                          : Colors.grey,
                    ),
                  ),
                  Switch(
                    value: _isExpertMode,
                    activeTrackColor: LithicaColors.alterationPurple,
                    onChanged: _setExpertMode,
                  ),
                  Text(
                    "Exp",
                    style: TextStyle(
                      fontSize: 10,
                      color: _isExpertMode
                          ? LithicaColors.alterationPurple
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.tune_rounded, size: 20),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => GeotechSettingsDialog(
                    controller: activeController,
                    authController: widget.authController,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Bar for Vertical / Narrow Mode
  Widget _buildBottomNav(BuildContext context, bool isDark) {
    final activeText = isDark
        ? LithicaColors.logoLime
        : const Color(0xFF2B6615);
    final inactiveText = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF64748B);

    final items = [
      {'title': 'Base KB', 'icon': Icons.menu_book},
      {'title': 'RMR', 'icon': Icons.grid_view},
      {'title': 'Q-System', 'icon': Icons.analytics},
      {'title': 'Hoek-Brown', 'icon': Icons.show_chart},
      {'title': 'ISRM', 'icon': Icons.verified},
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xF2071827) : const Color(0xFFFFFFFF),
        border: Border(
          top: BorderSide(
            color: LithicaColors.logoTeal.withValues(
              alpha: isDark ? 0.3 : 0.15,
            ),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (idx) {
          final isSel = _activeTabIndex == idx;
          final item = items[idx];
          return InkWell(
            onTap: () => setState(() => _activeTabIndex = idx),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSel
                    ? LithicaColors.logoGreen.withValues(
                        alpha: isDark ? 0.2 : 0.15,
                      )
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 20,
                    color: isSel ? activeText : inactiveText,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      color: isSel ? activeText : inactiveText,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
