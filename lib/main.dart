import 'package:flutter/material.dart';
import 'core/theme/giao_dien_app.dart';
import 'views/screens/man_hinh_menu.dart';

void main() {
  runApp(const UngDungCaro());
}

class UngDungCaro extends StatelessWidget {
  const UngDungCaro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cờ Caro',
      debugShowCheckedModeBanner: false,
      theme: GiaoDienApp.giaoDienToi,
      home: const ManHinhMenu(),
    );
  }
}