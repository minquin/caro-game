import 'package:flutter_test/flutter_test.dart';
import 'package:caro_project_cnttk25/core/enums/loai_nguoi_choi.dart';
import 'package:caro_project_cnttk25/core/enums/trang_thai_o.dart';
import 'package:caro_project_cnttk25/models/ban_co_model.dart';
import 'package:caro_project_cnttk25/models/nguoi_choi_model.dart';
import 'package:caro_project_cnttk25/models/o_co_model.dart';

void main() {
  group('BanCoModel', () {
    test('creates a square board with empty cells', () {
      final board = BanCoModel(kichThuoc: 7);

      expect(board.oCo, hasLength(7));
      expect(board.oCo.every((row) => row.length == 7), isTrue);
      expect(board.daDayBanCo(), isFalse);
      expect(board.layTrangThaiO(0, 0), TrangThaiO.trong);
    });

    test('rejects a non-positive board size', () {
      expect(() => BanCoModel(kichThuoc: 0), throwsArgumentError);
      expect(() => BanCoModel(kichThuoc: -1), throwsArgumentError);
    });

    test('sets and reads a cell, and rejects out-of-range coordinates', () {
      final board = BanCoModel(kichThuoc: 7);

      expect(board.datTrangThaiO(2, 4, TrangThaiO.x), isTrue);
      expect(board.layTrangThaiO(2, 4), TrangThaiO.x);
      expect(board.datTrangThaiO(-1, 4, TrangThaiO.o), isFalse);
      expect(board.datTrangThaiO(7, 4, TrangThaiO.o), isFalse);
      expect(board.layTrangThaiO(-1, 4), TrangThaiO.trong);
    });

    test('clears all cells and detects a full board', () {
      final board = BanCoModel(kichThuoc: 2);
      board.datTrangThaiO(0, 0, TrangThaiO.x);
      board.datTrangThaiO(0, 1, TrangThaiO.o);
      board.datTrangThaiO(1, 0, TrangThaiO.o);
      board.datTrangThaiO(1, 1, TrangThaiO.x);

      expect(board.daDayBanCo(), isTrue);
      board.xoaBanCo();
      expect(board.daDayBanCo(), isFalse);
      expect(board.oCo.expand((row) => row), everyElement(TrangThaiO.trong));
    });
  });

  group('NguoiChoiModel and OCoModel', () {
    test('stores player identity, piece type, and score', () {
      final player = NguoiChoiModel(
        maSo: 'A',
        tenHienThi: 'Người chơi A',
        loaiQuan: LoaiNguoiChoi.x,
      );
      player.diemSo++;

      expect(player.maSo, 'A');
      expect(player.tenHienThi, 'Người chơi A');
      expect(player.loaiQuan, LoaiNguoiChoi.x);
      expect(player.diemSo, 1);
    });

    test('stores cell coordinates and state', () {
      final cell = OCoModel(x: 2, y: 3, trangThai: TrangThaiO.o);

      expect(cell.x, 2);
      expect(cell.y, 3);
      expect(cell.trangThai, TrangThaiO.o);
    });
  });
}
