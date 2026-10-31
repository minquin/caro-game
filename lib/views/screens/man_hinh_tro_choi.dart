import 'package:flutter/material.dart';
import '../../controllers/dieu_khien_tro_choi.dart';
import '../widgets/widget_ban_co.dart';
import '../widgets/widget_thanh_dau.dart';

class ManHinhTroChoi extends StatefulWidget {
  final int kichThuocBanCo;
  final bool laDauVoiMay;

  const ManHinhTroChoi({
    Key? key,
    required this.kichThuocBanCo,
    required this.laDauVoiMay,
  }) : super(key: key);

  @override
  State<ManHinhTroChoi> createState() => _ManHinhTroChoiState();
}

class _ManHinhTroChoiState extends State<ManHinhTroChoi> {
  late DieuKhienTroChoi _boDieuKhien;
  bool _daHienThiDialog = false;

  static const Color xanhDam = Color(0xFF1765C5);

  @override
  void initState() {
    super.initState();
    _boDieuKhien = DieuKhienTroChoi(
      kichThuoc: widget.kichThuocBanCo,
      laDauVoiMay: widget.laDauVoiMay,
    );
    _boDieuKhien.addListener(_langNgheTrangThaiTroChoi);
  }

  void _langNgheTrangThaiTroChoi() {
    if (_boDieuKhien.troChoiKetThuc && !_daHienThiDialog) {
      _daHienThiDialog = true;
      _hienThiBangKetQua();
    }
  }

  void _hienThiBangKetQua() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          // Nới rộng chiều ngang tối thiểu của khung ra để không bị rớt dòng
          constraints: const BoxConstraints(minWidth: 330),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white24),
          ),
          title: const Text(
            'KẾT QUẢ VÁN ĐẤU',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          content: Text(
            _boDieuKhien.thongBaoKetQua,
            style: const TextStyle(color: Colors.white70, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Xem bàn cờ 👀',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _daHienThiDialog = false;
                        });
                        _boDieuKhien.choiLai();
                      },
                      child: const Text(
                        'Ván Mới 🚀',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _boDieuKhien.removeListener(_langNgheTrangThaiTroChoi);
    _boDieuKhien.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String tenCheDo = widget.laDauVoiMay ? '(VS AI)' : '(PvP)';
    String tieuDeSize = widget.kichThuocBanCo == 3
        ? '3x3 (Tic-Tac-Toe)'
        : '${widget.kichThuocBanCo}x${widget.kichThuocBanCo}';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background2.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: ListenableBuilder(
            listenable: _boDieuKhien,
            builder: (context, child) {
              return Column(
                children: [
                  // Thanh điều hướng trên cùng
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            'Kích Thước: $tieuDeSize $tenCheDo',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: xanhDam,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              color: const Color(0xFFEAF5FF).withOpacity(0.95),
                              shape: const CircleBorder(),
                              child: IconButton(
                                tooltip: 'Quay lại',
                                icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: xanhDam,
                                  size: 26,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: Material(
                                color:
                                    const Color(0xFFEAF5FF).withOpacity(0.95),
                                shape: const CircleBorder(),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.more_vert,
                                      color: xanhDam, size: 22),
                                ),
                              ),
                              onSelected: (value) {
                                if (value == 'new_game') {
                                  setState(() {
                                    _daHienThiDialog = false;
                                  });
                                  _boDieuKhien.choiLai();
                                } else if (value == 'reset_score') {
                                  setState(() {
                                    _daHienThiDialog = false;
                                  });
                                  _boDieuKhien.resetDiemSo();
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                const PopupMenuItem(
                                  value: 'new_game',
                                  child: Row(
                                    children: [
                                      Icon(Icons.refresh,
                                          color: Colors.blueAccent, size: 20),
                                      SizedBox(width: 10),
                                      Text('Ván mới'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'reset_score',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_sweep,
                                          color: Colors.redAccent, size: 20),
                                      SizedBox(width: 10),
                                      Text('Xóa điểm & Ván mới'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Thanh đầu hiển thị tỉ số, lượt đánh và thời gian đếm ngược
                  WidgetThanhDau(boDieuKhien: _boDieuKhien),

                  // Bàn cờ chính
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: WidgetBanCo(boDieuKhien: _boDieuKhien),
                        ),
                      ),
                    ),
                  ),

                  // Thanh điều khiển ở đáy: Giữ lại độc quyền nút Đầu Hàng
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF5FF).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF9CCBFF), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 220,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 11),
                              ),
                              icon: const Icon(Icons.flag,
                                  size: 18, color: Colors.white),
                              label: const Text(
                                'Đầu Hàng',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              onPressed: () {
                                if (_boDieuKhien.troChoiKetThuc) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Ván đấu đã kết thúc, vui lòng bấm Ván Mới!')),
                                  );
                                  return;
                                }
                                _boDieuKhien.dauHang();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
