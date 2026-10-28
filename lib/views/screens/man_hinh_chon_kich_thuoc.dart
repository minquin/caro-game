import 'package:flutter/material.dart';
import '../../core/constants/mau_sac_app.dart';
import 'man_hinh_tro_choi.dart';

class ManHinhChonKichThuoc extends StatelessWidget {
  final bool laDauVoiMay;

  const ManHinhChonKichThuoc({Key? key, required this.laDauVoiMay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String tenCheDo = laDauVoiMay ? 'Đấu với Máy (AI)' : 'Đấu 2 Người (PvP)';

    return Scaffold(
      backgroundColor: MauSacApp.nenToi,
      appBar: AppBar(
        backgroundColor: MauSacApp.nenThongTin,
        title: Text('Chọn Kích Thước ($tenCheDo)', style: const TextStyle(color: MauSacApp.chuSang, fontSize: 16)),
        iconTheme: const IconThemeData(color: MauSacApp.chuSang),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'BƯỚC 2: CHỌN BÀN CỜ',
                  style: TextStyle(color: MauSacApp.hieuUngPhatSang, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                const SizedBox(height: 20),

                _taoNutSize(context, 'Bàn cờ 3x3 (Tic-Tac-Toe)', 3),
                _taoNutSize(context, 'Bàn cờ 5x5', 5),
                _taoNutSize(context, 'Bàn cờ 7x7', 7),
                _taoNutSize(context, 'Bàn cờ 10x10', 10),
                _taoNutSize(context, 'Bàn cờ 15x15', 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _taoNutSize(BuildContext context, String tieuDe, int kichThuoc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MauSacApp.nenThongTin,
            side: const BorderSide(color: MauSacApp.duongLuoi),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ManHinhTroChoi(
                  kichThuocBanCo: kichThuoc,
                  laDauVoiMay: laDauVoiMay,
                ),
              ),
            );
          },
          child: Text(
            tieuDe,
            style: const TextStyle(fontSize: 15, color: MauSacApp.chuSang, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}