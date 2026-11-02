import 'package:flutter/material.dart';
import '../../utils/am_thanh_helper.dart';
import 'man_hinh_tro_choi.dart';

class ManHinhChonKichThuoc extends StatelessWidget {
  final bool laDauVoiMay;

  const ManHinhChonKichThuoc({Key? key, required this.laDauVoiMay}) : super(key: key);

  static const Color xanhDam = Color(0xFF1765C5);
  static const Color xanh = Color(0xFF3198F5);
  static const Color trang = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    // 📱 Kiểm tra tỷ lệ màn hình để tự động đổi ảnh nền dọc hoặc ngang
    var screenSize = MediaQuery.of(context).size;
    bool laManHinhDoc = screenSize.width < screenSize.height;

    String anhNen = laManHinhDoc
        ? 'assets/images/background_mobile.png' // Hoặc 'assets/images/background2_mobile.png'
        : 'assets/images/background.png';

    final List<int> cacKichThuoc = [3, 5, 7, 10, 15];

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
              // Nút quay lại
              Positioned(
                top: 12,
                left: 16,
                child: Material(
                  color: const Color(0xFFEAF5FF).withOpacity(0.95),
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: xanhDam),
                    onPressed: () {
                      AmThanhHelper.phatAmThanh('GenericClick.mp3');
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'CHỌN KÍCH THƯỚC BÀN CỜ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: xanhDam,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...cacKichThuoc.map((size) => Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: xanh,
                                    foregroundColor: trang,
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      side: const BorderSide(color: trang, width: 2),
                                    ),
                                  ),
                                  onPressed: () {
                                    AmThanhHelper.phatAmThanh('GenericClick.mp3');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ManHinhTroChoi(
                                          kichThuocBanCo: size,
                                          laDauVoiMay: laDauVoiMay,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    size == 3 ? '3 x 3 (Tic-Tac-Toe)' : '$size x $size',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )),
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
}