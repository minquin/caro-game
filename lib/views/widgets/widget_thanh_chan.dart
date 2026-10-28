import 'package:flutter/material.dart';
import '../../controllers/dieu_khien_tro_choi.dart';
import '../../core/constants/mau_sac_app.dart';

class WidgetThanhChan extends StatelessWidget {
  final DieuKhienTroChoi boDieuKhien;

  const WidgetThanhChan({Key? key, required this.boDieuKhien}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: MauSacApp.nenThongTin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã gửi lời đề nghị Xin Hòa!')),
              );
            },
            icon: const Icon(Icons.handshake, color: Colors.white),
            label: const Text('Xin Hòa', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[900]),
            onPressed: () => boDieuKhien.dauHang(),
            icon: const Icon(Icons.flag, color: Colors.white),
            label: const Text('Đầu Hàng', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
            onPressed: () => boDieuKhien.choiLai(),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text('Ván Mới', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}