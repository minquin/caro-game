import 'package:flutter/material.dart';

import '../constants/mau_sac_app.dart';

class GiaoDienApp {
  static ThemeData get giaoDienToi {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: MauSacApp.nenToi,
      cardColor: MauSacApp.nenThongTin,
      colorScheme: const ColorScheme.dark(
        surface: MauSacApp.nenThongTin,
      ),
    );
  }
}
