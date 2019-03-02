import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

Sounds sounds = Sounds._();

class Sounds {
  //the media file in application dir
  File _file;

  bool muted = false;

  Sounds._() {
    _init();
  }

  void _init() async {
    final audio = AudioCache();
    audio.load('music.mp3').then((file) {
      _file = file;
      debugPrint('file loaded : ${file.path}');
    }).catchError((e) {
      debugPrint('load music.mp3 failed : $e');
    });
  }

  void _play(Duration start, Duration length) async {
    if (_file == null || muted) {
      return;
    }
    final player = AudioPlayer();
    await player.play(_file.path, isLocal: true, position: start);
    await Future.delayed(length);
    await player.stop();
    player.release();
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
