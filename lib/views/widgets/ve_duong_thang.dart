import 'package:flutter/material.dart';
import 'dart:math';

class VeDuongThangThangCuoc extends CustomPainter {
  final Point<int> diemDau;
  final Point<int> diemCuoi;
  final int kichThuocBanCo;

  VeDuongThangThangCuoc({
    required this.diemDau,
    required this.diemCuoi,
    required this.kichThuocBanCo,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amberAccent // Màu gạch vàng rực rỡ
      ..strokeWidth = 6.0 // Độ dày đường gạch
      ..strokeCap = StrokeCap.round; // Bo tròn hai đầu mút cho mượt

    double cellWidth = size.width / kichThuocBanCo;
    double cellHeight = size.height / kichThuocBanCo;

    // 1. Tâm của ô đầu và ô cuối
    Offset start = Offset(
      diemDau.y * cellWidth + cellWidth / 2,
      diemDau.x * cellHeight + cellHeight / 2,
    );

    Offset end = Offset(
      diemCuoi.y * cellWidth + cellWidth / 2,
      diemCuoi.x * cellHeight + cellHeight / 2,
    );

    // 2. 🎯 Tính toán kéo dài thêm một đoạn ra phía ngoài ở cả 2 đầu (ví dụ thụt lề ra ngoài 40% kích thước 1 ô)
    double paddingExtension = cellWidth * 0.4; 
    
    // Vector hướng từ đầu đến cuối
    double dx = end.dx - start.dx;
    double dy = end.dy - start.dy;
    double length = sqrt(dx * dx + dy * dy);

    if (length > 0) {
      double unitDx = dx / length;
      double unitDy = dy / length;

      // Dịch điểm start lùi lại phía sau và điểm end tiến lên phía trước
      start = Offset(start.dx - unitDx * paddingExtension, start.dy - unitDy * paddingExtension);
      end = Offset(end.dx + unitDx * paddingExtension, end.dy + unitDy * paddingExtension);
    }

    // 3. Vẽ đường thẳng đã được nối dài ra ngoài
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}