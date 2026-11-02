import 'package:flutter/material.dart';
import '../../controllers/dieu_khien_tro_choi.dart';
import 'widget_o_co.dart';
import 've_duong_thang.dart'; // 🎨 Nhớ import file vẽ đường thẳng vừa tạo vào

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
          // 🎯 Bọc bàn cờ trong Stack để chồng lớp vẽ đường gạch chiến thắng lên trên
          child: Stack(
            children: [
              // 1. Cột các hàng ô cờ của bàn cờ
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(kichThuoc, (y) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(kichThuoc, (x) {
                      return WidgetOCo(
                        trangThai: boDieuKhien.banCo[y][x],
                        kichThuoc: kichThuocOCo,
                        khiNhan: () {
                          boDieuKhien.xuLyNuocDi(y, x);
                        },
                      );
                    }),
                  );
                }),
              ),

              // 2. 🎨 Lớp gạch ngang chiến thắng đè lên trên cùng khi trò chơi kết thúc
              if (boDieuKhien.troChoiKetThuc &&
                  boDieuKhien.diemDauThang != null &&
                  boDieuKhien.diemCuoiThang != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: VeDuongThangThangCuoc(
                        diemDau: boDieuKhien.diemDauThang!,
                        diemCuoi: boDieuKhien.diemCuoiThang!,
                        kichThuocBanCo: kichThuoc,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}