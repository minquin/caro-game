import 'package:flutter/material.dart';
import 'man_hinh_tro_choi.dart';

class ManHinhChonKichThuoc extends StatelessWidget {
  final bool laDauVoiMay;

  const ManHinhChonKichThuoc({Key? key, required this.laDauVoiMay})
      : super(key: key);

  static const Color xanhDam = Color(0xFF1765C5);
  static const Color xanh = Color(0xFF3198F5);
  static const Color trang = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final String tenCheDo =
        laDauVoiMay ? 'Đấu với Máy (AI)' : 'Đấu 2 Người (PvP)';

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
          child: Column(
            children: [
              // Thanh điều hướng trên cùng
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 20, 4),
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
                        onPressed: () => Navigator.pop(context),
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
                              const SizedBox(height: 110),
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
          child: Row(
            children: [
              // <-- Xóa chữ 'const' ở đây nhé!
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
                    // Chuyển const vào đây nếu muốn
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
