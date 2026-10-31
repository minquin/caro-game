import 'package:flutter/material.dart';
import 'man_hinh_chon_kich_thuoc.dart';

class ManHinhMenu extends StatelessWidget {
  const ManHinhMenu({Key? key}) : super(key: key);

  static const Color xanhDam = Color(0xFF1765C5);
  static const Color xanh = Color(0xFF3198F5);
  static const Color hong = Color(0xFFF34F9B);
  static const Color trang = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 130),
                        _taoNutMenu(
                          context,
                          title: 'Đấu 2 Người (PvP)',
                          subtitle: 'Hai người chơi chung một máy',
                          icon: Icons.sports_martial_arts_rounded,
                          mau: xanh,
                          laDauVoiMay: false,
                        ),
                        const SizedBox(height: 18),
                        _taoNutMenu(
                          context,
                          title: 'Đấu với Máy (PvE - AI)',
                          subtitle: 'Thách đấu với máy thông minh',
                          icon: Icons.smart_toy_rounded,
                          mau: hong,
                          laDauVoiMay: true,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _taoNutMenu(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color mau,
    required bool laDauVoiMay,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 104,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: mau,
          foregroundColor: trang,
          elevation: 9,
          shadowColor: mau.withOpacity(0.45),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(color: trang, width: 2.5),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ManHinhChonKichThuoc(laDauVoiMay: laDauVoiMay),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: trang.withOpacity(0.20),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, size: 34, color: trang),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: trang,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFF5F9FF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: trang,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
