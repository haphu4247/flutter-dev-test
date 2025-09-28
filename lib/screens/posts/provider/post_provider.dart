// Data model
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_dev/screens/posts/state/post_state.dart';
import 'package:flutter_test_dev/services/product_service.dart';


// StateNotifier
class PostsNotifier extends StateNotifier<PostsState> {
  final PostsService _service;
  static const int _itemsPerPage = 10;

  PostsNotifier(this._service)
      : super(PostsState(items: [], currentPage: 1, isLoadingMore: false, hasMore: true, error: null)) {
    loadInitialItems();
  }

  Future<void> loadInitialItems() async {
    if (state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true, currentPage: 1);
    final result = await _service.fetchPosts(page: state.currentPage, limit:  _itemsPerPage);
    final data = result.data;
    if (data != null && result.isSuccess) {
      state = state.copyWith(items: data, hasMore: data.length == _itemsPerPage, isLoadingMore: false);
      return;
    } else {
      //fallback in case of error
      state = state.copyWith(isLoadingMore: false, error: result.error);
    }
    // In case of error, we can set hasMore to false to prevent further loading
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.currentPage + 1;
    final result = await _service.fetchPosts(page: nextPage, limit: _itemsPerPage);
    final data = result.data;
    if (data != null && result.isSuccess) {
        state = state.copyWith(
        items: [...state.items, ...data],
        currentPage: nextPage,
        isLoadingMore: false,
        hasMore: data.length == _itemsPerPage,
      );
    } else {
      //fallback in case of error
      state = state.copyWith(isLoadingMore: false, error: result.error);
    }
  }
}

// Provider
final postNotifierProvider = StateNotifierProvider<PostsNotifier, PostsState>((ref) {
  return PostsNotifier(PostsService());
});