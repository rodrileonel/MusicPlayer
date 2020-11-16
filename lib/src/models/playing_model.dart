import 'package:flutter/material.dart';

class PlayingModel extends ChangeNotifier{
  bool _playing = false;
  Duration _songDuration = Duration(microseconds: 0);
  Duration _currentDuration = Duration(microseconds: 0);

  Duration get currentDuration => this._currentDuration;
  set currentDuration(Duration currentDuration) {
    this._currentDuration = currentDuration;
    notifyListeners();
  }

  Duration get songDuration => this._songDuration;
  set songDuration(Duration songDuration) {
    this._songDuration = songDuration;
    notifyListeners();
  }

  bool get playing => this._playing;

  set playing(bool playing) {
    this._playing = playing;
    notifyListeners();
  }

}