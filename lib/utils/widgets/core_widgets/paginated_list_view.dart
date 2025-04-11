import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:flutter/material.dart';

typedef ItemBuilder<T> = Widget Function(
    BuildContext context, T item, int index);
typedef LoadMoreCallback = Future<void> Function();

class PaginatedListView<T> extends StatefulWidget {
  const PaginatedListView({
    required this.items,
    required this.itemBuilder,
    required this.onLoadMore,
    super.key,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.scrollPhysics,
    this.separator,
  });

  final List<T> items;
  final ItemBuilder<T> itemBuilder;
  final LoadMoreCallback onLoadMore;
  final bool isLoadingMore;
  final bool hasMore;
  final EdgeInsets padding;
  final ScrollPhysics? scrollPhysics;
  final Widget? separator;

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  final ScrollController _controller = ScrollController();

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 100) {
      if (widget.hasMore && !widget.isLoadingMore) {
        widget.onLoadMore();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount =
        widget.items.length + (widget.isLoadingMore && widget.hasMore ? 1 : 0);

    return ListView.separated(
      controller: _controller,
      physics: widget.scrollPhysics ?? const BouncingScrollPhysics(),
      padding: widget.padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index < widget.items.length) {
          return widget.itemBuilder(context, widget.items[index], index);
        } else {
          return const LoadingWidget();
        }
      },
      separatorBuilder: (_, __) =>
          widget.separator ?? const SizedBox(height: 12),
    );
  }
}
