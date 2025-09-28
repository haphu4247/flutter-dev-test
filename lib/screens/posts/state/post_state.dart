
// State
import 'package:flutter_test_dev/base/api_client/base_api.dart';
import 'package:flutter_test_dev/models/product_model.dart';

class PostsState {
  final List<PostModel> items;
  final int currentPage;
  final bool isLoadingMore;
  final bool hasMore;
  final ApiError? error;

  PostsState({
    required this.items,
    required this.currentPage,
    required this.isLoadingMore,
    required this.hasMore,
    required this.error,
  });

  PostsState copyWith({
    List<PostModel>? items,
    int? currentPage,
    bool? isLoadingMore,
    bool? hasMore,
    ApiError? error,
  }) {
    return PostsState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}
