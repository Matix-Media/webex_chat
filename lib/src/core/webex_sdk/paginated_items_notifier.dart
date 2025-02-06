import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webex_chat/src/core/webex_sdk/webex_api.dart';

import 'models/paginated_response.dart';

class PaginatedItemsNotifier<T> extends StateNotifier<AsyncValue<List<T>>> {
  final Future<PaginatedResponse<T>> Function({String? cursor}) _fetcher;
  String? _nextCursor;
  bool _isLoadingMore = false;

  bool get hasMore => _nextCursor != null;

  PaginatedItemsNotifier(this._fetcher) : super(const AsyncLoading()) {
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final res = await _fetcher(cursor: _nextCursor);
      state = AsyncData(res.items);
      _nextCursor = res.nextCursor;
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || _nextCursor == null) return;

    _isLoadingMore = true;
    final currentItems = state.value ?? [];
    state = AsyncLoading<List<T>>().copyWithPrevious(state);

    try {
      final response = await _fetcher(cursor: _nextCursor);
      state = AsyncData(currentItems + response.items);
      _nextCursor = response.nextCursor;
    } catch (e, st) {
      state = AsyncError<List<T>>(e, st).copyWithPrevious(AsyncData(currentItems));
    } finally {
      _isLoadingMore = false;
    }
  }
}
