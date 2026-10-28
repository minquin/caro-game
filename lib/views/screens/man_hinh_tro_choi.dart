import 'package:flutter/material.dart';
import '../../controllers/dieu_khien_tro_choi.dart';
import '../../core/constants/mau_sac_app.dart';
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
      barrierDismissible: true, // Cho phép bấm ra ngoài vùng tối để ẩn bảng, soi lại bàn cờ!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white24),
          ),
          title: const Text(
            'KẾT QUẢ VÁN ĐẤU',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          content: Text(
            _boDieuKhien.thongBaoKetQua,
            style: const TextStyle(color: Colors.white70, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            // Nút 1: Đóng hộp thoại để soi kỹ bàn cờ
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Xem bàn cờ 👀',
                style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.w600),
              ),
            ),
            
            // Nút 2: Bắt đầu ván mới ngay lập tức
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
    String tieuDeSize = widget.kichThuocBanCo == 3 ? '3x3 (Tic-Tac-Toe)' : '${widget.kichThuocBanCo}x${widget.kichThuocBanCo}';

    return Scaffold(
      backgroundColor: MauSacApp.nenToi,
      appBar: AppBar(
        backgroundColor: MauSacApp.nenThongTin,
        title: Text(
          'Kích Thước: $tieuDeSize $tenCheDo',
          style: const TextStyle(color: MauSacApp.chuSang, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: MauSacApp.chuSang),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới / Ván mới',
            onPressed: () {
              setState(() {
                _daHienThiDialog = false;
              });
              _boDieuKhien.choiLai();
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _boDieuKhien,
        builder: (context, child) {
          return Column(
            children: [
              // Thanh đầu hiển thị tỉ số, lượt đánh và thời gian đếm ngược 30s
              WidgetThanhDau(boDieuKhien: _boDieuKhien),

              // Bàn cờ chính cố định co giãn linh hoạt
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

              // Thanh công cụ dưới chân (Footer): Xin hòa, Đầu hàng, Ván mới
              Container(
                padding: const EdgeInsets.all(12),
                color: MauSacApp.nenThongTin,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.amberAccent,
                        side: const BorderSide(color: Colors.amberAccent),
                      ),
                      icon: const Icon(Icons.handshake, size: 18),
                      label: const Text('Xin Hòa'),
                      onPressed: _boDieuKhien.troChoiKetThuc ? null : () {
                        bool chapNhanHoa = _boDieuKhien.xinHoa();
                        if (chapNhanHoa) {
                          setState(() {
                            _boDieuKhien.troChoiKetThuc = true;
                            _boDieuKhien.thongBaoKetQua = 'Ván đấu Hòa do đồng thuận! 🤝';
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đối phương từ chối cầu hòa!')),
                          );
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade800),
                      icon: const Icon(Icons.flag, size: 18, color: Colors.white),
                      label: const Text('Đầu Hàng', style: TextStyle(color: Colors.white)),
                      onPressed: _boDieuKhien.troChoiKetThuc ? null : () {
                        _boDieuKhien.dauHang();
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: MauSacApp.hieuUngPhatSang),
                      icon: const Icon(Icons.restart_alt, size: 18, color: Colors.black),
                      label: const Text('Ván Mới', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        setState(() {
                          _daHienThiDialog = false;
                        });
                        _boDieuKhien.choiLai();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}