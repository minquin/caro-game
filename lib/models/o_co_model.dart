import '../core/enums/trang_thai_o.dart';

class OCoModel {
  final int x;
  final int y;
  TrangThaiO trangThai;

  OCoModel({
    required this.x,
    required this.y,
    this.trangThai = TrangThaiO.trong,
  });
}