import 'package:flutter/material.dart';
import '../../utils/am_thanh_helper.dart';
import 'man_hinh_chon_kich_thuoc.dart';

class ManHinhMenu extends StatefulWidget {
  const ManHinhMenu({Key? key}) : super(key: key);

  @override
  State<ManHinhMenu> createState() => _ManHinhMenuState();
}

class _ManHinhMenuState extends State<ManHinhMenu> {
  @override
  void initState() {
    super.initState();
    AmThanhHelper.phatNhacNen('PG_4_vol0.15.mp3');
  }

  static const Color xanhDam = Color(0xFF1765C5);
  static const Color xanh = Color(0xFF3198F5);
  static const Color hong = Color(0xFFF34F9B);
  static const Color trang = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool laManHinhDoc = screenSize.width < screenSize.height;

    String anhNen = laManHinhDoc
        ? 'assets/images/background_mobile.png' // Hoặc tên file ảnh nền dọc menu của bà
        : 'assets/images/background.png';
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(anhNen),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 12,
                right: 16,
                child: Row(
                  children: [
                    Material(
                      color: const Color(0xFFEAF5FF).withOpacity(0.95),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: AmThanhHelper.dangTatNhacNen ? 'Bật Nhạc Nền' : 'Tắt Nhạc Nền',
                        icon: Icon(
                          AmThanhHelper.dangTatNhacNen ? Icons.music_off_rounded : Icons.music_note_rounded,
                          color: xanhDam,
                          size: 24,
                        ),
                        onPressed: () {
                          AmThanhHelper.toggleNhacNen();
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: const Color(0xFFEAF5FF).withOpacity(0.95),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: AmThanhHelper.dangTatTiengClick ? 'Bật Tiếng Click' : 'Tắt Tiếng Click',
                        icon: Icon(
                          AmThanhHelper.dangTatTiengClick ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                          color: xanhDam,
                          size: 24,
                        ),
                        onPressed: () {
                          AmThanhHelper.toggleTiengClick();
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Center(
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
              ),
            ],
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
          AmThanhHelper.phatAmThanh('GenericClick.mp3');
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