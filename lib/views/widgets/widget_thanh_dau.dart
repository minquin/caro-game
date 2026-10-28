import 'package:flutter/material.dart';
import '../../controllers/dieu_khien_tro_choi.dart';
import '../../core/constants/mau_sac_app.dart';
import '../../core/enums/loai_nguoi_choi.dart';

class WidgetThanhDau extends StatelessWidget {
  final DieuKhienTroChoi boDieuKhien;

  const WidgetThanhDau({Key? key, required this.boDieuKhien}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nguoiChoi1 = boDieuKhien.nguoiChoi1;
    final nguoiChoi2 = boDieuKhien.nguoiChoi2;
    final laLuotNguoiChoi1 = boDieuKhien.luotHienTai == nguoiChoi1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: MauSacApp.nenThongTin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _taoKhungNguoiChoi(nguoiChoi1, laLuotNguoiChoi1),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${nguoiChoi1.diemSo} - ${nguoiChoi2.diemSo}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: MauSacApp.chuSang,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: MauSacApp.nenToi,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${boDieuKhien.thoiGianConLai}s',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          _taoKhungNguoiChoi(nguoiChoi2, !laLuotNguoiChoi1),
        ],
      ),
    );
  }

  Widget _taoKhungNguoiChoi(nguoiChoi, bool laLuotHienTai) {
    // So sánh trực tiếp với LoaiNguoiChoi.x, KHÔNG dùng .name tránh lỗi NoSuchMethodError
    bool laQuanX = nguoiChoi.loaiQuan == LoaiNguoiChoi.x;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MauSacApp.nenToi,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: laLuotHienTai ? MauSacApp.hieuUngPhatSang : Colors.transparent,
          width: 2,
        ),
        boxShadow: laLuotHienTai
            ? [
                BoxShadow(
                  color: MauSacApp.hieuUngPhatSang.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Chống tràn pixel theo chiều dọc
        children: [
          Icon(
            laQuanX ? Icons.close : Icons.circle_outlined,
            color: laQuanX ? MauSacApp.nguoiChoiX : MauSacApp.nguoiChoiO,
            size: 32,
          ),
          const SizedBox(height: 4),
          Text(
            nguoiChoi.tenHienThi,
            style: const TextStyle(
              color: MauSacApp.chuSang,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
