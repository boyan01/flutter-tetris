import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

Sounds sounds = Sounds._();

class Sounds {
  final _audioPlayer = AudioCache(fixedPlayer: AudioPlayer());

  bool _initialized = false;

  bool _playing = false;

  bool muted = false;

  Sounds._() {
    _init();
  }

  void _init() async {
    final player = _audioPlayer.fixedPlayer;
    player.setReleaseMode(ReleaseMode.STOP);
    player.audioPlayerStateChangeHandler = (state) {
      if (state == AudioPlayerState.PLAYING) {
        player.pause();
        _initialized = true;
        player.audioPlayerStateChangeHandler = null;
      }
    };
    await _audioPlayer.play("music.mp3");
  }

  void _play(Duration start, Duration length) async {
    if (!_initialized || _playing || muted) {
      return;
    }
    _playing = true;
    final player = _audioPlayer.fixedPlayer;
    await player.seek(start);
    await player.resume();
    await Future.delayed(length);
    player.pause();
    _playing = false;
  }

  void start() {
    _play(
        const Duration(milliseconds: 3720), const Duration(milliseconds: 3622));
  }

  void clear() {
    _play(const Duration(milliseconds: 0), const Duration(milliseconds: 767));
  }

  void fall() {
    _play(
        const Duration(milliseconds: 1255), const Duration(milliseconds: 354));
  }

  void gameOver() {
    _play(
        const Duration(milliseconds: 8127), const Duration(milliseconds: 1143));
  }

  void rotate() {
    _play(const Duration(milliseconds: 2247), const Duration(milliseconds: 80));
  }

  void move() {
    _play(
        const Duration(milliseconds: 2908), const Duration(milliseconds: 143));
  }
}
