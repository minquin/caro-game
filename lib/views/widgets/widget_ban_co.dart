import 'package:flutter/material.dart';
import '../../controllers/dieu_khien_tro_choi.dart';
import 'widget_o_co.dart';

class WidgetBanCo extends StatelessWidget {
  final DieuKhienTroChoi boDieuKhien;

  const WidgetBanCo({
    Key? key,
    required this.boDieuKhien,
  }) : super(key: key);

  static const Color xanhDam = Color(0xFF1765C5);

  @override
  Widget build(BuildContext context) {
    int kichThuoc = boDieuKhien.banCo.length;

    // Tính kích thước ô cờ sao cho tổng bàn cờ 3x3, 5x5... to bằng bàn cờ 15x15 (tổng ~600px)
    double tongKichThuocMucTieu = 600.0;
    double kichThuocOCo = tongKichThuocMucTieu / kichThuoc;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: xanhDam,
          width: 3.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(kichThuoc, (y) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(kichThuoc, (x) {
                  return WidgetOCo(
                    trangThai: boDieuKhien.banCo[y][x],
                    kichThuoc: kichThuocOCo, // Truyền kích thước động vào ô cờ
                    khiNhan: () {
                      boDieuKhien.xuLyNuocDi(y, x);
                    },
                  );
                }),
              );
            }),
          ),
        ),
      ),
    );
  }
}