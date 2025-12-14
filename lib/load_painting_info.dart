import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'painting_info.dart';

class LoadPaintingInfo {
  // Loads PaintingInfo objects from an asset JSON file.
  // Your starter code references: text/image_list2.json
  static Future<List<PaintingInfo>> load(BuildContext context) async {
    final jsonString = await rootBundle.loadString('text/image_list2.json');
    final decoded = jsonDecode(jsonString);

    if (decoded is List) {
      return decoded.map((e) => PaintingInfo.fromJson(e)).toList();
    }

    // Optional safety: if JSON is wrapped in an object with a list inside it
    if (decoded is Map && decoded['paintings'] is List) {
      return (decoded['paintings'] as List)
          .map((e) => PaintingInfo.fromJson(e))
          .toList();
    }

    return <PaintingInfo>[];
  }
}
