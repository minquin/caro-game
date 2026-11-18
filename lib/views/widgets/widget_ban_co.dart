import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/enums/trang_thai_o.dart';
import 'widget_o_co.dart';
import 've_duong_thang.dart';

/// Widget hiển thị bàn cờ. Không phụ thuộc trực tiếp vào Controller.
class WidgetBanCo extends StatelessWidget {
  final List<List<TrangThaiO>> banCo;
  final bool troChoiKetThuc;
  final Point<int>? diemDauThang;
  final Point<int>? diemCuoiThang;
  final void Function(int hang, int cot) khiChonO;

  const WidgetBanCo({
    Key? key,
    required this.banCo,
    required this.troChoiKetThuc,
    required this.diemDauThang,
    required this.diemCuoiThang,
    required this.khiChonO,
  }) : super(key: key);

  static const Color xanhDam = Color(0xFF1765C5);

  @override
  Widget build(BuildContext context) {
    final int kichThuoc = banCo.length;
    final double kichThuocOCo = 600.0 / kichThuoc;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: xanhDam, width: 3.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Stack(children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(kichThuoc, (hang) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(kichThuoc, (cot) => WidgetOCo(
                  trangThai: banCo[hang][cot],
                  kichThuoc: kichThuocOCo,
                  khiNhan: () => khiChonO(hang, cot),
                )),
              )),
            ),
            if (troChoiKetThuc && diemDauThang != null && diemCuoiThang != null)
              Positioned.fill(child: IgnorePointer(child: CustomPaint(
                painter: VeDuongThangThangCuoc(diemDau: diemDauThang!, diemCuoi: diemCuoiThang!, kichThuocBanCo: kichThuoc),
              ))),
          ]),
        ),
      ),
    );
  }
}
