import 'package:flutter/material.dart';
import '../../core/constants/mau_sac_app.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: khiNhan,
      child: Container(
        width: kichThuoc,
        height: kichThuoc,
        decoration: BoxDecoration(
          border: Border.all(color: MauSacApp.duongLuoi, width: 0.5),
          color: MauSacApp.nenToi,
        ),
        child: Center(
          child: _taoKyHieu(),
        ),
      ),
    );
  }

  Widget _taoKyHieu() {
    switch (trangThai) {
      case TrangThaiO.x:
        return const Text(
          'X',
          style: TextStyle(
            color: MauSacApp.nguoiChoiX,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        );
      case TrangThaiO.o:
        return const Text(
          'O',
          style: TextStyle(
            color: MauSacApp.nguoiChoiO,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        );
      case TrangThaiO.trong:
        return const SizedBox.shrink();
    }
  }
}
