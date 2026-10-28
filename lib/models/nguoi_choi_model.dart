import '../core/enums/loai_nguoi_choi.dart';

class NguoiChoiModel {
  final String maSo;
  final String tenHienThi;
  final LoaiNguoiChoi loaiQuan;
  int diemSo;

  NguoiChoiModel({
    required this.maSo,
    required this.tenHienThi,
    required this.loaiQuan,
    this.diemSo = 0,
  });
}