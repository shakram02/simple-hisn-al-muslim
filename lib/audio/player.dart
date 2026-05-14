import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:azkar/audio/cache.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Single-stream zikr audio player.
///
/// Only one zikr's audio plays at a time. Calling [play] for a different
/// item stops the current track first. The current playing item is exposed
/// via [playingItemIdNotifier] so UIs can render the right control state.
class ZikrAudioPlayer {
  static final ZikrAudioPlayer _instance = ZikrAudioPlayer._();
  factory ZikrAudioPlayer() => _instance;
  ZikrAudioPlayer._();

  final AudioPlayer _player = AudioPlayer();
  bool _sessionConfigured = false;

  /// `null` when nothing plays; otherwise the currently-playing item id.
  final ValueNotifier<int?> playingItemIdNotifier = ValueNotifier<int?>(null);

  AudioPlayer get rawPlayer => _player;

  Future<void> _ensureSession() async {
    if (_sessionConfigured) return;
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playingItemIdNotifier.value = null;
      }
    });
    _sessionConfigured = true;
  }

  Future<void> play(int itemId, String url) async {
    await _ensureSession();
    if (playingItemIdNotifier.value == itemId) return;
    await _player.stop();
    final file = await AudioCache().getOrDownload(itemId, url);
    try {
      await _player.setFilePath(file.path);
      playingItemIdNotifier.value = itemId;
      // Fire-and-forget: just_audio's play() Future resolves when playback
      // ENDS, not when it starts. Awaiting it would freeze our caller for
      // the entire duration of the audio. Errors during playback come via
      // playerStateStream / errorStream instead.
      unawaited(_player.play());
    } catch (e) {
      debugPrint('audio: play failed for $itemId: $e');
      playingItemIdNotifier.value = null;
      rethrow;
    }
  }

  Future<void> stop() async {
    await _player.stop();
    playingItemIdNotifier.value = null;
  }
}
