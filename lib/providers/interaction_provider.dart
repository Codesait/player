import 'package:app/models/song.dart';
import 'package:app/providers/song_provider.dart';
import 'package:app/utils/api_request.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class InteractionProvider with ChangeNotifier {
  SongProvider _songProvider;

  final BehaviorSubject<Song> _songLikeToggled = BehaviorSubject();
  ValueStream<Song> get songLikeToggleStream => _songLikeToggled.stream;

  InteractionProvider({required SongProvider songProvider})
      : _songProvider = songProvider;

  List<Song> get favorites =>
      _songProvider.songs.where((song) => song.liked).toList();

  Future<void> like(Song song) async {
    // broadcast the event first regardless
    song.liked = true;
    _songLikeToggled.add(song);
    await post('interaction/like', data: {'song': song.id});
  }

  Future<void> unlike(Song song) async {
    // broadcast the event first regardless
    song.liked = false;
    _songLikeToggled.add(song);
    await post('interaction/like', data: {'song': song.id});
  }

  Future<void> toggleLike(Song song) async {
    return song.liked ? unlike(song) : like(song);
  }
}