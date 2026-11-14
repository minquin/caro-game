import 'package:flutter/material.dart';

class WidgetThanhDau extends StatelessWidget {
  final String tenNguoiChoi1;
  final String tenNguoiChoi2;
  final int diemNguoiChoi1;
  final int diemNguoiChoi2;
  final bool nguoiChoi1LaX;
  final bool luotNguoiChoi1;
  final int thoiGianConLai;

  const WidgetThanhDau({
    Key? key,
    required this.tenNguoiChoi1,
    required this.tenNguoiChoi2,
    required this.diemNguoiChoi1,
    required this.diemNguoiChoi2,
    required this.nguoiChoi1LaX,
    required this.luotNguoiChoi1,
    required this.thoiGianConLai,
  }) : super(key: key);

  static const Color xanhDam = Color(0xFF1765C5);
  static const Color xanh = Color(0xFF3198F5);
  static const Color hong = Color(0xFFF34F9B);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _taoKhungNguoiChoi(tenNguoiChoi1, nguoiChoi1LaX, luotNguoiChoi1)),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$diemNguoiChoi1 - $diemNguoiChoi2',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: xanhDam)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF9CCBFF), width: 1.5),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.timer_rounded, color: hong, size: 15),
                  const SizedBox(width: 4),
                  Text('${thoiGianConLai}s', style: const TextStyle(color: xanhDam, fontSize: 12, fontWeight: FontWeight.w900)),
                ]),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(child: _taoKhungNguoiChoi(tenNguoiChoi2, !nguoiChoi1LaX, !luotNguoiChoi1)),
        ],
      ),
    );
  }

  Widget _taoKhungNguoiChoi(String ten, bool laQuanX, bool laLuotHienTai) {
    final Color mau = laQuanX ? xanh : hong;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: laLuotHienTai ? mau : const Color(0xFFBBD9F7), width: laLuotHienTai ? 2.5 : 1.5),
        boxShadow: [if (laLuotHienTai) BoxShadow(color: mau.withOpacity(0.25), blurRadius: 8, spreadRadius: 1)],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(laQuanX ? Icons.close_rounded : Icons.circle_outlined, color: mau, size: 22),
        const SizedBox(height: 2),
        Text(ten, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
            style: const TextStyle(color: xanhDam, fontSize: 11, fontWeight: FontWeight.w900)),
        if (laLuotHienTai)
          const Padding(padding: EdgeInsets.only(top: 2), child: Text('ĐANG ĐÁNH', style: TextStyle(color: xanhDam, fontSize: 8, fontWeight: FontWeight.bold))),
      ]),
    );
  }
}
