import 'package:flutter/material.dart';
import '../../controllers/dieu_khien_tro_choi.dart';
import 'widget_o_co.dart';

class WidgetBanCo extends StatelessWidget {
  final DieuKhienTroChoi boDieuKhien;

  const WidgetBanCo({Key? key, required this.boDieuKhien}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int kichThuoc = boDieuKhien.banCo.length;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(kichThuoc, (y) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(kichThuoc, (x) {
              return WidgetOCo(
                trangThai: boDieuKhien.banCo[y][x],
                khiNhan: () => boDieuKhien.xuLyNuocDi(y, x),
              );
            }),
          );
        }),
      ),
    );
  }
}