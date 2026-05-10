import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/models.dart';

/// Genera y comparte un PDF del reporte de entrenamiento.
class PdfExportService {
  /// Colores del brand ProgressUP
  static const _pink = PdfColor.fromInt(0xFFFF006E);
  static const _cyan = PdfColor.fromInt(0xFF00F5FF);
  static const _bg = PdfColor.fromInt(0xFF0D0D1A);
  static const _card = PdfColor.fromInt(0xFF1A1A2E);
  static const _textPrimary = PdfColor.fromInt(0xFFFFFFFF);
  static const _textSecondary = PdfColor.fromInt(0xFFB0B0CC);
  static const _success = PdfColor.fromInt(0xFF39FF14);

  static Future<void> exportWorkoutReport({
    required String title,
    required String timerString,
    required int xpEarned,
    required DateTime fecha,
    required List<Map<String, dynamic>> ejercicios,
  }) async {
    final pdf = pw.Document();

    // Calcular totales
    final totalSeries = ejercicios.fold<int>(
      0,
      (sum, e) => sum + (e['seriesCompletadas'] as int? ?? 0),
    );
    final fechaStr = DateFormat('dd MMM yyyy, HH:mm').format(fecha);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          buildBackground: (ctx) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(color: _bg),
          ),
        ),
        build: (ctx) => [
          _buildHeader(title, fechaStr),
          pw.SizedBox(height: 24),
          _buildStatCards(timerString, xpEarned, totalSeries, ejercicios.length),
          pw.SizedBox(height: 24),
          _buildEjerciciosSection(ejercicios),
          pw.SizedBox(height: 32),
          _buildFooter(),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename:
          'progressup_${title.toLowerCase().replaceAll(' ', '_')}_${DateFormat('yyyyMMdd').format(fecha)}.pdf',
    );
  }

  static Future<void> exportAggregatedReport({
    required String periodName,
    required List<WorkoutModel> workouts,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final pdf = pw.Document();

    int totalXp = 0;
    int totalDuration = 0;
    int totalSeries = 0;
    int totalWorkouts = workouts.length;

    for (var w in workouts) {
      totalXp += w.puntosGenerados ?? 0;
      totalDuration += w.duracion ?? 0;
      totalSeries += w.ejerciciosCompletados.fold<int>(
          0, (sum, e) => sum + (e['seriesCompletadas'] as int? ?? 0));
    }

    final String timerString = _formatDuration(totalDuration);
    String dateRangeStr = '';
    if (periodName == 'Total') {
      dateRangeStr = 'Desde ${DateFormat('dd MMM yyyy').format(workouts.last.fecha)}';
    } else {
      dateRangeStr = '${DateFormat('dd MMM yyyy').format(startDate)} - ${DateFormat('dd MMM yyyy').format(endDate)}';
    }

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          buildBackground: (ctx) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(color: _bg),
          ),
        ),
        build: (ctx) => [
          _buildHeader('REPORTE ${periodName.toUpperCase()}', dateRangeStr),
          pw.SizedBox(height: 24),
          _buildStatCards(timerString, totalXp, totalSeries, totalWorkouts),
          pw.SizedBox(height: 24),
          _buildDetailedWorkoutsSection(workouts),
          pw.SizedBox(height: 32),
          _buildFooter(),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename:
          'progressup_reporte_${periodName.toLowerCase()}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }

  static String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '${h}h ${m.toString().padLeft(2, '0')}m';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ──────────────────────────────────────────
  // Header
  // ──────────────────────────────────────────
  static pw.Widget _buildHeader(String title, String fechaStr) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: _card,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: _pink, width: 1.5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'PROGRESSUP',
                style: pw.TextStyle(
                  color: _pink,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                title,
                style: pw.TextStyle(
                  color: _textPrimary,
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                fechaStr,
                style: const pw.TextStyle(color: _textSecondary, fontSize: 11),
              ),
            ],
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: pw.BoxDecoration(
              color: _pink,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text(
              'REPORTE\nDE SESIÓN',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                color: _textPrimary,
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  // Stat cards row
  // ──────────────────────────────────────────
  static pw.Widget _buildStatCards(
    String timerString,
    int xp,
    int totalSeries,
    int totalEjercicios,
  ) {
    return pw.Row(
      children: [
        _statCard('⏱ DURACIÓN', timerString, _cyan),
        pw.SizedBox(width: 12),
        _statCard('⚡ XP GANADOS', '+$xp XP', _pink),
        pw.SizedBox(width: 12),
        _statCard('🏋 SERIES', '$totalSeries', _success),
        pw.SizedBox(width: 12),
        _statCard('💪 EJERCICIOS', '$totalEjercicios', _cyan),
      ],
    );
  }

  static pw.Widget _statCard(String label, String value, PdfColor accent) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(14),
        decoration: pw.BoxDecoration(
          color: _card,
          borderRadius: pw.BorderRadius.circular(8),
          border: pw.Border.all(color: accent, width: 0.8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label,
                style: const pw.TextStyle(color: _textSecondary, fontSize: 8)),
            pw.SizedBox(height: 6),
            pw.Text(value,
                style: pw.TextStyle(
                    color: accent,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  // Ejercicios table
  // ──────────────────────────────────────────
  static pw.Widget _buildEjerciciosSection(List<Map<String, dynamic>> ejercicios) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'EJERCICIOS COMPLETADOS',
          style: pw.TextStyle(
            color: _cyan,
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Container(
          decoration: pw.BoxDecoration(
            color: _card,
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.Column(
            children: [
              // Header de tabla
              _tableRow(
                cells: ['EJERCICIO', 'SERIES', 'OBJETIVO', 'PESO', 'REPS'],
                isHeader: true,
              ),
              pw.Divider(color: _pink, thickness: 0.5),
              // Filas de ejercicios
              ...ejercicios.asMap().entries.map((entry) {
                final i = entry.key;
                final e = entry.value;
                final completadas = e['seriesCompletadas'] as int? ?? 0;
                final target = e['seriesTarget'] as int? ?? 0;
                final done = completadas >= target;
                return pw.Column(
                  children: [
                    _tableRow(
                      cells: [
                        e['name'] as String? ?? '-',
                        '$completadas',
                        '$target',
                        e['weight'] as String? ?? '-',
                        '${e['reps'] ?? '-'}',
                      ],
                      isHeader: false,
                      isEven: i % 2 == 0,
                      accentColor: done ? _success : _textSecondary,
                    ),
                    if (i < ejercicios.length - 1)
                      pw.Divider(
                          color: PdfColor.fromInt(0xFF2A2A3E), thickness: 0.5),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildDetailedWorkoutsSection(List<WorkoutModel> workouts) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'DETALLE DE SESIONES',
          style: pw.TextStyle(
            color: _cyan,
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        pw.SizedBox(height: 12),
        ...workouts.map((w) {
          final fechaStr = DateFormat('dd MMM yyyy, HH:mm').format(w.fecha);
          final ejercicios = w.ejerciciosCompletados;
          
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: _card,
                    borderRadius: const pw.BorderRadius.vertical(top: pw.Radius.circular(8)),
                    border: pw.Border.all(color: _pink, width: 0.5),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            w.title ?? 'Entrenamiento',
                            style: pw.TextStyle(
                              color: _textPrimary,
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            fechaStr,
                            style: const pw.TextStyle(
                              color: _textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            '+${w.puntosGenerados ?? 0} XP',
                            style: pw.TextStyle(
                              color: _pink,
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            _formatDuration(w.duracion ?? 0),
                            style: const pw.TextStyle(
                              color: _cyan,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Tabla de ejercicios
                pw.Container(
                  decoration: pw.BoxDecoration(
                    color: _card,
                    borderRadius: const pw.BorderRadius.vertical(bottom: pw.Radius.circular(8)),
                    border: pw.Border.all(color: PdfColor.fromInt(0xFF2A2A3E), width: 0.5),
                  ),
                  child: pw.Column(
                    children: [
                      _tableRow(
                        cells: ['EJERCICIO', 'SERIES', 'OBJETIVO', 'PESO', 'REPS'],
                        isHeader: true,
                      ),
                      pw.Divider(color: _pink, thickness: 0.5),
                      ...ejercicios.asMap().entries.map((entry) {
                        final i = entry.key;
                        final e = entry.value;
                        final completadas = e['seriesCompletadas'] as int? ?? 0;
                        final target = e['seriesTarget'] as int? ?? 0;
                        final done = completadas >= target;
                        return pw.Column(
                          children: [
                            _tableRow(
                              cells: [
                                e['name'] as String? ?? '-',
                                '$completadas',
                                '$target',
                                e['weight'] as String? ?? '-',
                                '${e['reps'] ?? '-'}',
                              ],
                              isHeader: false,
                              isEven: i % 2 == 0,
                              accentColor: done ? _success : _textSecondary,
                            ),
                            if (i < ejercicios.length - 1)
                              pw.Divider(
                                  color: PdfColor.fromInt(0xFF2A2A3E), thickness: 0.5),
                          ],
                        );
                      }),
                      if (ejercicios.isEmpty)
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(12),
                          child: pw.Text('No hay ejercicios registrados', style: const pw.TextStyle(color: _textSecondary, fontSize: 10)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  static pw.Widget _tableRow({
    required List<String> cells,
    required bool isHeader,
    bool isEven = false,
    PdfColor? accentColor,
  }) {
    final bg = isHeader
        ? PdfColor.fromInt(0xFF2A1A2E)
        : isEven
            ? _card
            : PdfColor.fromInt(0xFF1E1E32);

    final style = isHeader
        ? pw.TextStyle(
            color: _pink,
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1,
          )
        : pw.TextStyle(
            color: accentColor ?? _textPrimary,
            fontSize: 10,
          );

    final flexes = [3, 1, 1, 1, 1];

    return pw.Container(
      color: bg,
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: pw.Row(
        children: List.generate(cells.length, (i) {
          return pw.Expanded(
            flex: flexes[i],
            child: pw.Text(
              cells[i],
              style: style,
              textAlign: i == 0 ? pw.TextAlign.left : pw.TextAlign.center,
            ),
          );
        }),
      ),
    );
  }

  // ──────────────────────────────────────────
  // Footer
  // ──────────────────────────────────────────
  static pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColor.fromInt(0xFF2A2A3E), width: 0.5),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            'Generado por ',
            style: const pw.TextStyle(color: _textSecondary, fontSize: 9),
          ),
          pw.Text(
            'ProgressUP',
            style: pw.TextStyle(
                color: _pink, fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            ' · Entrena. Compite. Sube de nivel.',
            style: const pw.TextStyle(color: _textSecondary, fontSize: 9),
          ),
        ],
      ),
    );
  }
}
