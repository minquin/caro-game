import 'package:flutter/material.dart';
import '../../core/constants/mau_sac_app.dart';

/// Thanh thao tac chi nhan callback tu man hinh, khong phu thuoc Controller.
class WidgetThanhChan extends StatelessWidget {
  final VoidCallback onXinHoa;
  final VoidCallback onDauHang;

  const WidgetThanhChan({
    Key? key,
    required this.onXinHoa,
    required this.onDauHang,
  }) : super(key: key);

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
            onPressed: onXinHoa,
            icon: const Icon(Icons.handshake, color: Colors.white),
            label: const Text('Xin Hòa', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[900]),
            onPressed: onDauHang,
            icon: const Icon(Icons.flag, color: Colors.white),
            label: const Text('Đầu Hàng', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
