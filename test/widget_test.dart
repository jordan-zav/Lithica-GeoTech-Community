import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lithica_geotech/src/app.dart';
import 'package:lithica_geotech/src/presentation/geotech_home_page.dart';
import 'package:lithica_geotech/src/presentation/hoek_brown_page.dart';
import 'package:lithica_geotech/src/presentation/isrm_page.dart';
import 'package:lithica_geotech/src/presentation/kb_page.dart';
import 'package:lithica_geotech/src/presentation/q_system_page.dart';
import 'package:lithica_geotech/src/presentation/rmr_page.dart';

void main() {
  testWidgets('Lithica GeoTech smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LithicaGeoTechApp());
    expect(find.byType(LithicaGeoTechApp), findsOneWidget);
  });

  testWidgets('La interfaz principal respeta las zonas seguras del sistema', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GeotechHomePage()));
    await tester.pump();

    final safeArea = find.byType(SafeArea);
    expect(safeArea, findsOneWidget);
    expect(
      find.descendant(of: safeArea, matching: find.text('Base KB')),
      findsOneWidget,
    );
  });

  testWidgets('RMR muestra auditoria adicional solo en modo experto', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: RMRPage(isExpertMode: true))),
    );
    await tester.pump();

    expect(find.text('Auditoría experta activa'), findsOneWidget);
    expect(
      find.text('Descomposición y trazabilidad del cálculo'),
      findsOneWidget,
    );
  });

  testWidgets('Q actualiza visualmente ESR al cambiar la excavacion', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: QSystemPage(isExpertMode: true))),
    );
    await tester.pump();

    await tester.ensureVisible(find.byKey(const ValueKey('q_esr_preset')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('q_esr_preset')));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Labores mineras temporales').last);
    await tester.pumpAndSettle();

    final field = tester.widget<TextFormField>(
      find.byKey(const ValueKey('q_esr_field')),
    );
    expect(field.controller?.text, '3.0');
    expect(find.byIcon(Icons.code), findsNothing);
  });

  testWidgets('Q permite elegir las tres ediciones implementadas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: QSystemPage(isExpertMode: true))),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('q_version_selector')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Barton, Lien & Lunde (1974)'), findsWidgets);
    expect(find.textContaining('Grimstad & Barton (1993)'), findsWidgets);
    expect(find.textContaining('Barton (2002)'), findsWidgets);
  });

  testWidgets(
    'Q mantiene el resultado a la derecha con ancho util suficiente',
    (WidgetTester tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1000);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: QSystemPage(isExpertMode: true)),
        ),
      );
      await tester.pump();

      final formLeft = tester
          .getTopLeft(find.byKey(const ValueKey('q_form_card')))
          .dx;
      final resultLeft = tester
          .getTopLeft(find.byKey(const ValueKey('q_results_card')))
          .dx;

      expect(resultLeft, greaterThan(formLeft));
    },
  );

  testWidgets('Hoek-Brown desplaza toda la pagina en formato vertical', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(338, 700);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: HoekBrownPage(isExpertMode: true)),
      ),
    );
    await tester.pumpAndSettle();

    final pageScroll = find.byType(SingleChildScrollView);
    final title = find.textContaining('Criterio Cero-Linear');

    expect(pageScroll, findsOneWidget);
    expect(title, findsOneWidget);

    final initialTop = tester.getTopLeft(title).dy;
    await tester.drag(pageScroll, const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(title).dy, lessThan(initialTop));
  });

  final portraitPages = <(String, Widget, String)>[
    ('Base KB', const KBPage(isExpertMode: true), 'Biblioteca Geotécnica'),
    ('RMR', const RMRPage(isExpertMode: true), 'Calculadora RMR'),
    (
      'Q-System',
      const QSystemPage(isExpertMode: true),
      'Clasificación Q-System',
    ),
    ('ISRM', const ISRMPage(isExpertMode: true), 'Compendio Oficial'),
  ];

  for (final pageCase in portraitPages) {
    testWidgets('${pageCase.$1} usa un solo scroll de pagina en vertical', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(338, 700);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: pageCase.$2)));
      await tester.pumpAndSettle();

      final pageScroll = find.byType(SingleChildScrollView);
      final title = find.textContaining(pageCase.$3);

      expect(pageScroll, findsOneWidget);
      expect(title, findsOneWidget);

      final initialTop = tester.getTopLeft(title).dy;
      await tester.drag(pageScroll, const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(title).dy, lessThan(initialTop));
    });
  }

  final landscapePages = <(String, Widget, String)>[
    ('Base KB', const KBPage(isExpertMode: true), 'Biblioteca Geotécnica'),
    ('RMR', const RMRPage(isExpertMode: true), 'Calculadora RMR'),
    (
      'Q-System',
      const QSystemPage(isExpertMode: true),
      'Clasificación Q-System',
    ),
    (
      'Hoek-Brown',
      const HoekBrownPage(isExpertMode: true),
      'Criterio Cero-Linear',
    ),
    ('ISRM', const ISRMPage(isExpertMode: true), 'Compendio Oficial'),
  ];

  for (final pageCase in landscapePages) {
    testWidgets('${pageCase.$1} conserva scroll interno en horizontal', (
      WidgetTester tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1200, 700);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: pageCase.$2)));
      await tester.pumpAndSettle();

      final internalScrolls = find.byType(SingleChildScrollView);
      final title = find.textContaining(pageCase.$3);

      expect(internalScrolls, findsWidgets);
      expect(title, findsOneWidget);

      final initialTop = tester.getTopLeft(title).dy;
      await tester.drag(internalScrolls.first, const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(title).dy, initialTop);
    });
  }
}
