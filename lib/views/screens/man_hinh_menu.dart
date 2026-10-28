import 'package:flutter/material.dart';
import '../../core/constants/mau_sac_app.dart';
import 'man_hinh_chon_kich_thuoc.dart';

class ManHinhMenu extends StatelessWidget {
  const ManHinhMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MauSacApp.nenToi,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'CỜ CARO',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    color: MauSacApp.chuSang,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'BƯỚC 1: CHỌN CHẾ ĐỘ CHƠI',
                  style: TextStyle(color: MauSacApp.hieuUngPhatSang, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                const SizedBox(height: 40),

                // Nút chọn PvP
                _taoNutMenu(
                  context,
                  title: '⚔️ Đấu 2 Người (PvP)',
                  subtitle: 'Hai người chơi chung một máy',
                  laDauVoiMay: false,
                ),
                const SizedBox(height: 16),

                // Nút chọn PvE
                _taoNutMenu(
                  context,
                  title: '🤖 Đấu với Máy (PvE - AI)',
                  subtitle: 'Thách đấu với máy thông minh',
                  laDauVoiMay: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _taoNutMenu(BuildContext context, {required String title, required String subtitle, required bool laDauVoiMay}) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MauSacApp.nenThongTin,
          side: const BorderSide(color: MauSacApp.hieuUngPhatSang, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () {
          // Chuyển sang Bước 2: Chọn kích thước bàn cờ, mang theo thông tin laDauVoiMay
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ManHinhChonKichThuoc(laDauVoiMay: laDauVoiMay),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MauSacApp.chuSang)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}