import 'dart:convert';
import 'dart:isolate';

import 'package:charity_app/core/config/res/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Isolate function: reads SVGs as strings and encodes them to bytes
void _svgDecodeIsolate(List<dynamic> args) async {
  final sendPort = args[0] as SendPort;
  final svgPaths = args[1] as List<String>;

  final Map<String, Uint8List> svgBytes = {};
  for (final path in svgPaths) {
    try {
      final data = await rootBundle.loadString(path);
      svgBytes[path] = Uint8List.fromList(utf8.encode(data));
    } catch (_) {}
  }

  sendPort.send(svgBytes);
}

/// Runs only once at app startup
Future<void> precacheSvgAssetsInBackground() async {
  final receivePort = ReceivePort();

  // Spawn isolate with just paths (lightweight)
  await Isolate.spawn(
      _svgDecodeIsolate, [receivePort.sendPort, AppAssets.svg.values.map((e) => e.path).toList()]);

  receivePort.listen((svgBytesMap) async {
    final map = svgBytesMap as Map<String, Uint8List>;

    // Schedule caching asynchronously (doesn't block frame)
    for (final entry in map.entries) {
      Future.microtask(() async {
        final loader = SvgBytesLoader(entry.value);
        await svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
      });
    }

    debugPrint('✅ SVGs caching scheduled (non-blocking).');
  });
}
