import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class MakamNote {
  final String traditionalName; // Dügâh, Segâh, Çârgâh vb.
  final String standardName;    // La, Si koma b. vb.
  final String accidental;      // "none", "flat", "sharp", "koma_flat", "koma_sharp"
  final double frequency;       // Ses tınlama frekansı (Hz)
  final int staffIndex;         // E4 line'a göre basamak konumu (E4 = 0)

  const MakamNote({
    required this.traditionalName,
    required this.standardName,
    required this.accidental,
    required this.frequency,
    required this.staffIndex,
  });
}

class MakamStaff extends StatelessWidget {
  final List<MakamNote> notes;
  final int selectedNoteIndex;
  final ValueChanged<int> onNoteTapped;

  const MakamStaff({
    super.key,
    required this.notes,
    required this.selectedNoteIndex,
    required this.onNoteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = 160;

        return GestureDetector(
          onTapDown: (details) {
            final double tapX = details.localPosition.dx;
            final double tapY = details.localPosition.dy;
            
            // Tıklanan konuma en yakın notayı bulma
            final double startX = 60.0;
            final double endX = width - 40.0;
            final double usableWidth = endX - startX;
            final double noteSpacing = notes.length > 1 ? usableWidth / (notes.length - 1) : 0;

            int closestIndex = -1;
            double minDistance = double.infinity;

            for (int i = 0; i < notes.length; i++) {
              final double noteX = startX + i * noteSpacing;
              // Yalnızca yatay uzaklığı kontrol et (tıklamayı kolaylaştırmak için)
              final double distance = (tapX - noteX).abs();
              if (distance < minDistance && distance < (noteSpacing / 1.5)) {
                minDistance = distance;
                closestIndex = i;
              }
            }

            if (closestIndex != -1) {
              onNoteTapped(closestIndex);
            }
          },
          child: Container(
            height: height,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F11),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E1E22), width: 1),
            ),
            child: CustomPaint(
              size: Size(width, height),
              painter: StaffPainter(
                notes: notes,
                selectedNoteIndex: selectedNoteIndex,
              ),
            ),
          ),
        );
      },
    );
  }
}

class StaffPainter extends CustomPainter {
  final List<MakamNote> notes;
  final int selectedNoteIndex;

  StaffPainter({
    required this.notes,
    required this.selectedNoteIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    
    // Çizgi aralığı (Staff line spacing)
    final double S = 10.0;
    
    // Birinci çizginin (Mi4 / E4) dikey konumu
    final double yBottomLine = height / 2 + 1.5 * S;

    // 1. Dizek (Porte) Çizgilerini Çiz (5 Çizgi)
    final paintStaff = Paint()
      ..color = const Color(0xFF2C2C30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < 5; i++) {
      final double y = yBottomLine - i * S;
      canvas.drawLine(Offset(20, y), Offset(width - 20, y), paintStaff);
    }

    // 2. Sol Anahtarı (G-Clef) Çizimi (Stylized Minimalist)
    _drawStylizedGClef(canvas, Offset(25, yBottomLine), S);

    // 3. Notaları Çiz
    final double startX = 60.0;
    final double endX = width - 40.0;
    final double usableWidth = endX - startX;
    final double noteSpacing = notes.length > 1 ? usableWidth / (notes.length - 1) : 0;

    for (int i = 0; i < notes.length; i++) {
      final note = notes[i];
      final isSelected = i == selectedNoteIndex;

      final double noteX = startX + i * noteSpacing;
      // Natanın dikey konumu: E4 (0. basamak) yBottomLine seviyesindedir.
      // Her basamak S/2 kadar yukarı kayar.
      final double noteY = yBottomLine - (note.staffIndex * S / 2);

      // A. Ek Çizgileri (Ledger Lines) Çiz
      _drawLedgerLines(canvas, noteX, noteY, note.staffIndex, yBottomLine, S);

      // B. Değiştirici İşaretleri (Accidentals) Çiz
      _drawAccidental(canvas, Offset(noteX - 14, noteY), note.accidental, S);

      // C. Nota Kafasını (Note Head) Çiz
      _drawNoteHead(canvas, Offset(noteX, noteY), S, isSelected);

      // D. Nota Alt Etiketlerini Çiz
      _drawNoteLabels(canvas, Offset(noteX, yBottomLine + 3 * S), note, isSelected);
    }
  }

  void _drawStylizedGClef(Canvas canvas, Offset offset, double S) {
    final paint = Paint()
      ..color = AppColors.accentAmber.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final path = Path();
    double x = offset.dx;
    double y = offset.dy; // y corresponds to E4 line (first line)

    // Sleek minimalist G-clef
    path.moveTo(x + 12, y - 2 * S);
    path.quadraticBezierTo(x + 18, y - 2.5 * S, x + 18, y - 3.2 * S);
    path.quadraticBezierTo(x + 18, y - 4 * S, x + 12, y - 4 * S);
    path.quadraticBezierTo(x + 6, y - 4 * S, x + 6, y - 3.2 * S);
    path.quadraticBezierTo(x + 6, y - 2 * S, x + 20, y - S);
    path.quadraticBezierTo(x + 30, y, x + 24, y + S);
    path.quadraticBezierTo(x + 16, y + 2 * S, x + 10, y + S);
    path.quadraticBezierTo(x + 4, y, x + 12, y - 0.5 * S);
    path.quadraticBezierTo(x + 20, y - S, x + 20, y - 2.5 * S);
    path.lineTo(x + 12, y + 2.5 * S);
    path.quadraticBezierTo(x + 8, y + 3.0 * S, x + 4, y + 2.6 * S);

    canvas.drawPath(path, paint);
  }

  void _drawLedgerLines(Canvas canvas, double x, double y, int staffIndex, double yBottomLine, double S) {
    final paintLedger = Paint()
      ..color = const Color(0xFF444448)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double lineLength = 22.0;

    // Alt ek çizgiler (Ledger lines below staff: C4 ve altı, yani staffIndex <= -2)
    if (staffIndex <= -2) {
      // C4 çizgisi (index -2)
      canvas.drawLine(Offset(x - lineLength/2, yBottomLine + S), Offset(x + lineLength/2, yBottomLine + S), paintLedger);
    }
    if (staffIndex <= -4) {
      // A3 çizgisi (index -4)
      canvas.drawLine(Offset(x - lineLength/2, yBottomLine + 2 * S), Offset(x + lineLength/2, yBottomLine + 2 * S), paintLedger);
    }

    // Üst ek çizgiler (Ledger lines above staff: A5 ve üstü, yani staffIndex >= 10)
    if (staffIndex >= 10) {
      // A5 çizgisi (index 10)
      canvas.drawLine(Offset(x - lineLength/2, yBottomLine - 5 * S), Offset(x + lineLength/2, yBottomLine - 5 * S), paintLedger);
    }
    if (staffIndex >= 12) {
      // C6 çizgisi (index 12)
      canvas.drawLine(Offset(x - lineLength/2, yBottomLine - 6 * S), Offset(x + lineLength/2, yBottomLine - 6 * S), paintLedger);
    }
  }

  void _drawAccidental(Canvas canvas, Offset offset, String type, double S) {
    if (type == "none") return;

    final paint = Paint()
      ..color = AppColors.accentAmber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final double x = offset.dx;
    final double y = offset.dy;

    if (type == "flat") {
      final path = Path()
        ..moveTo(x, y - S)
        ..lineTo(x, y + 0.3 * S)
        ..quadraticBezierTo(x + 0.5 * S, y + 0.3 * S, x + 0.6 * S, y - 0.1 * S)
        ..quadraticBezierTo(x + 0.6 * S, y - 0.5 * S, x, y - 0.2 * S);
      canvas.drawPath(path, paint);
    } 
    else if (type == "koma_flat") {
      // Turkish Koma Flat: standard flat with a slash through it
      final path = Path()
        ..moveTo(x, y - S)
        ..lineTo(x, y + 0.3 * S)
        ..quadraticBezierTo(x + 0.5 * S, y + 0.3 * S, x + 0.6 * S, y - 0.1 * S)
        ..quadraticBezierTo(x + 0.6 * S, y - 0.5 * S, x, y - 0.2 * S);
      canvas.drawPath(path, paint);
      
      // Slash line
      canvas.drawLine(
        Offset(x - 2, y - 0.2 * S),
        Offset(x + 7, y - 0.6 * S),
        paint,
      );
    } 
    else if (type == "sharp") {
      canvas.drawLine(Offset(x, y - 0.7 * S), Offset(x, y + 0.7 * S), paint);
      canvas.drawLine(Offset(x + 0.3 * S, y - 0.8 * S), Offset(x + 0.3 * S, y + 0.6 * S), paint);
      canvas.drawLine(Offset(x - 0.2 * S, y - 0.2 * S), Offset(x + 0.5 * S, y - 0.1 * S), paint);
      canvas.drawLine(Offset(x - 0.2 * S, y + 0.1 * S), Offset(x + 0.5 * S, y + 0.2 * S), paint);
    } 
    else if (type == "koma_sharp") {
      // Turkish Koma Sharp: single vertical line with two slanting lines
      canvas.drawLine(Offset(x + 0.15 * S, y - 0.7 * S), Offset(x + 0.15 * S, y + 0.7 * S), paint);
      canvas.drawLine(Offset(x - 0.2 * S, y - 0.2 * S), Offset(x + 0.5 * S, y - 0.1 * S), paint);
      canvas.drawLine(Offset(x - 0.2 * S, y + 0.1 * S), Offset(x + 0.5 * S, y + 0.2 * S), paint);
    }
  }

  void _drawNoteHead(Canvas canvas, Offset offset, double S, bool isSelected) {
    final paint = Paint()
      ..color = isSelected ? AppColors.accentOlive : AppColors.primaryText
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(-pi / 6); // standard tilted note head
    
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 1.2 * S, height: 0.85 * S),
      paint,
    );
    canvas.restore();

    if (isSelected) {
      // Delicate pulse shadow/glow on selected note
      final paintGlow = Paint()
        ..color = AppColors.accentOlive.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      canvas.drawCircle(offset, 1.1 * S, paintGlow);
    }
  }

  void _drawNoteLabels(Canvas canvas, Offset offset, MakamNote note, bool isSelected) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Nota Adı (e.g., Sol)
    textPainter.text = TextSpan(
      text: note.standardName.split(' ')[0], // Sadece ana nota ismini yaz
      style: TextStyle(
        color: isSelected ? AppColors.accentAmber : AppColors.secondaryText,
        fontSize: 10,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(offset.dx - textPainter.width / 2, offset.dy));
  }

  @override
  bool shouldRepaint(covariant StaffPainter oldDelegate) {
    return oldDelegate.selectedNoteIndex != selectedNoteIndex || oldDelegate.notes != notes;
  }
}
