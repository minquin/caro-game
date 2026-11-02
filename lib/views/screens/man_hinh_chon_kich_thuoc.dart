import 'package:flutter/material.dart';
import '../../utils/am_thanh_helper.dart';
import 'man_hinh_tro_choi.dart';

class ManHinhChonKichThuoc extends StatefulWidget {
  final bool laDauVoiMay;

  const ManHinhChonKichThuoc({Key? key, required this.laDauVoiMay})
      : super(key: key);

  @override
  State<ManHinhChonKichThuoc> createState() => _ManHinhChonKichThuocState();
}

class _ManHinhChonKichThuocState extends State<ManHinhChonKichThuoc> {
  static const Color xanhDam = Color(0xFF1765C5);
  static const Color xanh = Color(0xFF3198F5);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool laManHinhDoc = screenSize.width < screenSize.height;
    String anhNen = laManHinhDoc
      ? 'assets/images/background_mobile.png' // Hoặc 'assets/images/background2_mobile.png'
      : 'assets/images/background.png';
    final String tenCheDo =
        widget.laDauVoiMay ? 'Đấu với Máy (AI)' : 'Đấu 2 Người (PvP)';

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 16, 4),
                child: Row(
                  children: [
                    Material(
                      color: const Color(0xFFEAF5FF).withOpacity(0.95),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Quay lại',
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: xanhDam,
                          size: 28,
                        ),
                        onPressed: () {
                          AmThanhHelper.phatAmThanh('GenericClick.mp3');
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Chọn bàn cờ  •  $tenCheDo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: xanhDam,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Material(
                      color: const Color(0xFFEAF5FF).withOpacity(0.95),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: AmThanhHelper.dangTatNhacNen ? 'Bật Nhạc Nền' : 'Tắt Nhạc Nền',
                        icon: Icon(
                          AmThanhHelper.dangTatNhacNen ? Icons.music_off_rounded : Icons.music_note_rounded,
                          color: xanhDam,
                          size: 22,
                        ),
                        onPressed: () {
                          AmThanhHelper.toggleNhacNen();
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    Material(
                      color: const Color(0xFFEAF5FF).withOpacity(0.95),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: AmThanhHelper.dangTatTiengClick ? 'Bật Tiếng Click' : 'Tắt Tiếng Click',
                        icon: Icon(
                          AmThanhHelper.dangTatTiengClick ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                          color: xanhDam,
                          size: 22,
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
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 120),
                              _taoNutSize(
                                context,
                                'Bàn cờ 3x3 (Tic-Tac-Toe)',
                                3,
                              ),
                              _taoNutSize(context, 'Bàn cờ 5x5', 5),
                              _taoNutSize(context, 'Bàn cờ 7x7', 7),
                              _taoNutSize(context, 'Bàn cờ 10x10', 10),
                              _taoNutSize(context, 'Bàn cờ 15x15', 15),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _taoNutSize(
    BuildContext context,
    String tieuDe,
    int kichThuoc,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF9FCFF).withOpacity(0.97),
            foregroundColor: xanhDam,
            elevation: 5,
            shadowColor: const Color(0x553B8DE5),
            padding: const EdgeInsets.symmetric(horizontal: 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: const BorderSide(
                color: Color(0xFF9CCBFF),
                width: 2.5,
              ),
            ),
          ),
          onPressed: () {
            AmThanhHelper.phatAmThanh('GenericClick.mp3');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ManHinhTroChoi(
                  kichThuocBanCo: kichThuoc,
                  laDauVoiMay: widget.laDauVoiMay,
                ),
              ),
            );
          },
          child: Row(
            children: [
              const Icon(
                Icons.grid_view_rounded,
                size: 31,
                color: xanh,
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Text(
                  tieuDe,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: xanhDam,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 32,
                color: xanh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}