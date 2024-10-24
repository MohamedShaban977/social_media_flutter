import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_model.dart';

class PreviewMediaViewModel {
  static final mediaIndexProvider = StateNotifierProvider<MediaIndexNotifier, int>((ref) => MediaIndexNotifier(0));
  static final postProvider = StateNotifierProvider<PostNotifier, PostModel?>((ref) => PostNotifier(null));
}

class MediaIndexNotifier extends StateNotifier<int> {
  MediaIndexNotifier(super.key);

  void set(int index) => state = index;
}

class PostNotifier extends StateNotifier<PostModel?> {
  PostNotifier(super.key);

  void set(PostModel post) => state = post;
}
