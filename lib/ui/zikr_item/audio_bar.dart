import 'package:azkar/audio/player.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/ui/components/app_colors.dart';
import 'package:azkar/ui/components/soft_card.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Audio controls for a single zikr item, placed below the zikr card.
///
/// The play/pause icon always reflects the user's *intent*:
///   - tap play → icon flips to pause immediately, even while the audio
///     is still downloading. A muted spinner appears next to the time
///     label to signal background work.
///   - tap pause while actively playing → returns to play icon.
///
/// Tapping the button while a download is in flight is a no-op; users
/// wait the (typically <2 s) download window.
class AudioBar extends StatefulWidget {
  final int itemId;
  final String audioUrl;
  const AudioBar({super.key, required this.itemId, required this.audioUrl});

  @override
  State<AudioBar> createState() => _AudioBarState();
}

class _AudioBarState extends State<AudioBar> {
  bool _loading = false;

  @override
  void didUpdateWidget(AudioBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The parent reuses this same widget element across page changes
    // (no item-id key on AudioBar). When the item changes, drop any
    // load state from the previous item's tap — a download still in
    // flight for the old item shouldn't keep this bar spinning.
    if (oldWidget.itemId != widget.itemId && _loading) {
      _loading = false;
    }
  }

  Future<void> _onPlayTap() async {
    if (_loading) return; // ignore taps while the file is downloading

    final player = ZikrAudioPlayer();
    final l10n = AppLocalizations.of(context);

    // THIS item is the active track — toggle play/pause on the live player.
    if (player.playingItemIdNotifier.value == widget.itemId) {
      if (player.rawPlayer.playing) {
        await player.rawPlayer.pause();
      } else {
        await player.rawPlayer.play();
      }
      return;
    }

    // Different (or no) track is active — load + play this one.
    setState(() => _loading = true);
    try {
      await player.play(widget.itemId, widget.audioUrl);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.audioDownloadFailed)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = ZikrAudioPlayer();
    // Primary (teal) for the audio affordance — gold is reserved for
    // completion moments (gilt-manuscript reference). Audio is a
    // utility, not a celebration.
    final accent = AppColors.of(context).primary;

    return ValueListenableBuilder<int?>(
      valueListenable: player.playingItemIdNotifier,
      builder: (context, playingId, _) {
        final isActive = playingId == widget.itemId;
        return StreamBuilder<PlayerState>(
          stream: player.rawPlayer.playerStateStream,
          builder: (context, snap) {
            final isPlayingNow = isActive && (snap.data?.playing ?? false);
            // Intent: pause icon when the user has asked for playback —
            // either we're loading their request, or the track is active.
            final showPause = _loading || isPlayingNow;
            return SoftCard(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Transform.flip(
                      // RTL locales (Arabic, Persian) read right-to-left, so
                      // the play arrow should point left to follow reading
                      // direction. Pause is symmetric — flipping it is a
                      // visual no-op, so we don't branch on `showPause`.
                      flipX: Directionality.of(context) == TextDirection.rtl,
                      child: Icon(
                        showPause ? Icons.pause_circle : Icons.play_circle,
                        color: accent,
                        size: 36,
                      ),
                    ),
                    onPressed: _onPlayTap,
                  ),
                  Expanded(
                    child: isActive
                        ? _ActiveProgress(
                            player: player.rawPlayer,
                            loading: _loading,
                          )
                        : _IdleProgress(loading: _loading),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ActiveProgress extends StatelessWidget {
  final AudioPlayer player;
  final bool loading;
  const _ActiveProgress({required this.player, required this.loading});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final accent = colors.primary;
    final mutedColor = colors.textTertiary;

    return StreamBuilder<Duration?>(
      stream: player.durationStream,
      builder: (context, durSnap) {
        final duration = durSnap.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: player.positionStream,
          builder: (context, posSnap) {
            final position = posSnap.data ?? Duration.zero;
            final clamped = position > duration ? duration : position;
            final maxMs = duration.inMilliseconds.toDouble();
            return Row(
              children: [
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      trackHeight: 3,
                      overlayShape: SliderComponentShape.noOverlay,
                      activeTrackColor: accent,
                      thumbColor: accent,
                    ),
                    child: Slider(
                      min: 0,
                      max: maxMs > 0 ? maxMs : 1,
                      value: clamped.inMilliseconds.toDouble().clamp(
                        0,
                        maxMs > 0 ? maxMs : 1,
                      ),
                      onChanged: maxMs > 0
                          ? (value) {
                              player.seek(
                                Duration(milliseconds: value.round()),
                              );
                            }
                          : null,
                    ),
                  ),
                ),
                Text(
                  _formatTime(clamped, duration),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: mutedColor,
                      ),
                ),
                if (loading) _DownloadSpinner(color: mutedColor),
              ],
            );
          },
        );
      },
    );
  }

  String _formatTime(Duration position, Duration total) {
    String f(Duration d) {
      final m = d.inMinutes.remainder(60).toString();
      final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$m:$s';
    }

    return total.inMilliseconds <= 0
        ? f(position)
        : '${f(position)} / ${f(total)}';
  }
}

class _IdleProgress extends StatelessWidget {
  final bool loading;
  const _IdleProgress({required this.loading});

  @override
  Widget build(BuildContext context) {
    final mutedColor = AppColors.of(context).iconMuted;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: mutedColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Text(
          '0:00',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: mutedColor,
              ),
        ),
        if (loading) _DownloadSpinner(color: mutedColor),
      ],
    );
  }
}

/// Small muted progress indicator shown next to the time label when the
/// audio file is being downloaded for the first time.
class _DownloadSpinner extends StatelessWidget {
  final Color color;
  const _DownloadSpinner({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8),
      child: SizedBox(
        width: 12,
        height: 12,
        child: CircularProgressIndicator(strokeWidth: 2, color: color),
      ),
    );
  }
}
