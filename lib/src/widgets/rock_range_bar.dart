import 'package:flutter/material.dart';
import '../domain/geotech_models.dart';
import '../theme/lithica_theme.dart';

class RockRangeBar extends StatelessWidget {
  const RockRangeBar({
    super.key,
    required this.sources,
  });

  final List<GeotechSource> sources;

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) return const SizedBox.shrink();

    double minAll = sources.first.ucsRange[0];
    double maxAll = sources.first.ucsRange[1];

    for (final s in sources) {
      if (s.ucsRange[0] < minAll) minAll = s.ucsRange[0];
      if (s.ucsRange[1] > maxAll) maxAll = s.ucsRange[1];
    }

    final span = maxAll - minAll == 0 ? 1.0 : maxAll - minAll;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            const Text(
              "Rango Bibliográfico Comparativo UCS (MPa)",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              "${minAll.toInt()} - ${maxAll.toInt()} MPa",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: LithicaColors.alterationPurple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth;
            return Container(
              height: 28,
              width: trackWidth,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF123149) : const Color(0xFFE2EBF4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: LithicaColors.logoTeal.withValues(alpha: 0.3)),
              ),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          LithicaColors.logoTeal.withValues(alpha: 0.4),
                          LithicaColors.logoGreen.withValues(alpha: 0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  ...sources.map((src) {
                    final avg = (src.ucsRange[0] + src.ucsRange[1]) / 2;
                    final pct = ((avg - minAll) / span).clamp(0.0, 1.0);
                    final posX = (trackWidth - 24) * pct;

                    return Positioned(
                      left: posX,
                      top: 4,
                      child: Tooltip(
                        message: "${src.author} (${src.year}): ${src.ucsRange[0].toInt()}-${src.ucsRange[1].toInt()} MPa",
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: LithicaColors.alterationPurple, width: 2.5),
                            boxShadow: const [
                              BoxShadow(color: Colors.black38, blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
