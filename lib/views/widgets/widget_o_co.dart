import 'package:flutter/material.dart';
import '../../core/enums/trang_thai_o.dart';

class WidgetOCo extends StatelessWidget {
  final TrangThaiO trangThai;
  final VoidCallback khiNhan;
  final double kichThuoc;

  const WidgetOCo({
    Key? key,
    required this.trangThai,
    required this.khiNhan,
    this.kichThuoc = 40.0,
  }) : super(key: key);

  static const Color xanh = Color(0xFF3198F5);
  static const Color hong = Color(0xFFF34F9B);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: khiNhan,
      child: Container(
        width: kichThuoc,
        height: kichThuoc,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFBBD9F7),
            width: 0.8,
          ),
          color: const Color(0xFFFDFEFF),
        ),
        child: Center(
          child: _taoKyHieu(),
        ),
      ),
    );
  }

  Widget _taoKyHieu() {
    // Tự động scale cỡ chữ theo kích thước ô cờ để không bị quá nhỏ khi bàn cờ 3x3 phóng to
    double fontSize = kichThuoc * 0.55;

    switch (trangThai) {
      case TrangThaiO.x:
        return Text(
          'X',
          style: TextStyle(
            color: xanh,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        );

      case TrangThaiO.o:
        return Text(
          'O',
          style: TextStyle(
            color: hong,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        );

      case TrangThaiO.trong:
        return const SizedBox.shrink();
    }
  }
}