import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// App-private cache of zikr audio files, keyed by item ID.
///
/// On first request for a given item, the file is downloaded and written
/// atomically (via a `.part` temp file then rename) so partial downloads
/// never leak into the cache.
class AudioCache {
  static final AudioCache _instance = AudioCache._();
  factory AudioCache() => _instance;
  AudioCache._();

  static const _subdir = 'audio_cache';
  static const _downloadTimeout = Duration(seconds: 30);

  Directory? _cacheDir;

  Future<Directory> _dir() async {
    if (_cacheDir != null) return _cacheDir!;
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, _subdir));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _cacheDir = dir;
    return dir;
  }

  Future<File> _fileFor(int itemId) async {
    final dir = await _dir();
    return File(p.join(dir.path, '$itemId.mp3'));
  }

  /// Returns the local file for [itemId], downloading from [url] on cache
  /// miss. Throws if the network fetch fails or returns a non-200 status.
  Future<File> getOrDownload(int itemId, String url) async {
    final file = await _fileFor(itemId);
    if (await file.exists() && await file.length() > 0) {
      return file;
    }

    final tempFile = File('${file.path}.part');
    if (await tempFile.exists()) {
      try {
        await tempFile.delete();
      } catch (_) {}
    }

    final response = await http.get(Uri.parse(url)).timeout(_downloadTimeout);
    if (response.statusCode != 200) {
      throw HttpException(
        'audio fetch failed with status ${response.statusCode}',
        uri: Uri.parse(url),
      );
    }

    await tempFile.writeAsBytes(response.bodyBytes, flush: true);
    await tempFile.rename(file.path);
    debugPrint('audio: cached $itemId (${response.bodyBytes.length} bytes)');
    return file;
  }

  /// Returns the set of item IDs currently cached on disk. Used by the
  /// player UI to decide whether to show audio controls while offline.
  Future<Set<int>> cachedItemIds() async {
    final dir = await _dir();
    final ids = <int>{};
    try {
      await for (final entry in dir.list()) {
        if (entry is! File) continue;
        if (p.extension(entry.path) != '.mp3') continue;
        final name = p.basenameWithoutExtension(entry.path);
        final id = int.tryParse(name);
        if (id != null) ids.add(id);
      }
    } catch (_) {}
    return ids;
  }

  /// Best-effort wipe of the entire cache. Not used in v1.1, kept for
  /// future "clear cache" affordance in settings.
  Future<void> clear() async {
    final dir = await _dir();
    try {
      await for (final entry in dir.list()) {
        if (entry is File) {
          try {
            await entry.delete();
          } catch (_) {}
        }
      }
    } catch (_) {}
  }
}
