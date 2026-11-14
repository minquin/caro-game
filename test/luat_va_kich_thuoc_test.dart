import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:caro_project_cnttk25/controllers/bo_xu_ly_luat.dart';
import 'package:caro_project_cnttk25/core/enums/trang_thai_o.dart';
import 'package:caro_project_cnttk25/models/ban_co_model.dart';
import 'package:caro_project_cnttk25/views/screens/man_hinh_chon_kich_thuoc.dart';

void main() {
  testWidgets('only 7x7, 10x10, and 15x15 boards are offered',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ManHinhChonKichThuoc(laDauVoiMay: false),
      ),
    );

    expect(find.text('Bàn cờ 7x7'), findsOneWidget);
    expect(find.text('Bàn cờ 10x10'), findsOneWidget);
    expect(find.text('Bàn cờ 15x15'), findsOneWidget);
    expect(find.text('Bàn cờ 3x3 (Tic-Tac-Toe)'), findsNothing);
    expect(find.text('Bàn cờ 5x5'), findsNothing);
  });

  test('rule helper detects five consecutive pieces vertically', () {
    final board = BanCoModel(kichThuoc: 7);
    for (var row = 1; row <= 5; row++) {
      board.datTrangThaiO(row, 3, TrangThaiO.x);
    }

    expect(BoXuLyLuat.kiemTraThang(board, 3, 3, TrangThaiO.x), isTrue);
  });

  test('rule helper detects five consecutive pieces diagonally', () {
    final board = BanCoModel(kichThuoc: 7);
    for (var index = 0; index < 5; index++) {
      board.datTrangThaiO(index, index, TrangThaiO.o);
    }

    expect(BoXuLyLuat.kiemTraThang(board, 2, 2, TrangThaiO.o), isTrue);
  });

  test('rule helper detects five consecutive pieces on anti-diagonal', () {
    final board = BanCoModel(kichThuoc: 7);
    for (var index = 0; index < 5; index++) {
      board.datTrangThaiO(index, 6 - index, TrangThaiO.x);
    }

    expect(BoXuLyLuat.kiemTraThang(board, 2, 4, TrangThaiO.x), isTrue);
  });

  test('rule helper rejects fewer than five consecutive pieces', () {
    final board = BanCoModel(kichThuoc: 7);
    for (var column = 1; column <= 4; column++) {
      board.datTrangThaiO(3, column, TrangThaiO.x);
    }

    expect(BoXuLyLuat.kiemTraThang(board, 3, 3, TrangThaiO.x), isFalse);
  });

  test('rule helper accepts five in a row with blocked ends', () {
    final board = BanCoModel(kichThuoc: 7);
    for (var column = 1; column <= 5; column++) {
      board.datTrangThaiO(3, column, TrangThaiO.x);
    }
    board.datTrangThaiO(3, 0, TrangThaiO.o);
    board.datTrangThaiO(3, 6, TrangThaiO.o);

    expect(BoXuLyLuat.kiemTraThang(board, 3, 3, TrangThaiO.x), isTrue);
  });
}
