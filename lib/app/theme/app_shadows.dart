import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const card = <BoxShadow>[
    BoxShadow(color: Color(0x140F172A), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const elevated = <BoxShadow>[
    BoxShadow(color: Color(0x1F0F172A), blurRadius: 32, offset: Offset(0, 12)),
  ];

  static const button = <BoxShadow>[
    BoxShadow(color: Color(0x332563EB), blurRadius: 16, offset: Offset(0, 6)),
  ];
}
