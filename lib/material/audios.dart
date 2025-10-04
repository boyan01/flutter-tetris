import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class Sound extends StatefulWidget {
  final Widget child;

  const Sound({super.key, required this.child});

  @override
  SoundState createState() => SoundState();

  static SoundState of(BuildContext context) {
    final state = context.findAncestorStateOfType<SoundState>();
    assert(state != null, 'can not find Sound widget');
    return state!;
  }
}

const sounds = [
  'clean.mp3',
  'drop.mp3',
  'explosion.mp3',
  'move.mp3',
  'rotate.mp3',
  'start.mp3'
];

class SoundState extends State<Sound> {
  final _soundPlayers = <String, AudioPool>{};

  bool mute = false;

  void _play(String name) {
    final player = _soundPlayers[name];
    if (player != null && !mute) {
      player.start();
    }
  }

  @override
  void initState() {
    super.initState();
    FlameAudio.updatePrefix('assets/audios/');
    for (final sound in sounds) {
      FlameAudio.createPool(sound, maxPlayers: 3).then((pool) {
        _soundPlayers[sound] = pool;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    FlameAudio.audioCache.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void start() {
    _play('start.mp3');
  }

  void clear() {
    _play('clean.mp3');
  }

  void fall() {
    _play('drop.mp3');
  }

  void rotate() {
    _play('rotate.mp3');
  }

  void move() {
    _play('move.mp3');
  }
}
