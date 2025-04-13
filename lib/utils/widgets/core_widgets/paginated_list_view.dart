import 'dart:async';

import 'package:fairway/export.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:flutter/material.dart';

typedef ItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);
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
    this.scrollDirection = Axis.vertical,
    this.separator,
  });

  final List<T> items;
  final ItemBuilder<T> itemBuilder;
  final LoadMoreCallback onLoadMore;
  final bool isLoadingMore;
  final bool hasMore;
  final EdgeInsets padding;
  final ScrollPhysics? scrollPhysics;
  final Axis scrollDirection;
  final Widget? separator;

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  final ScrollController _controller = ScrollController();
  Timer? _debounce;

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      final maxScroll = _controller.position.maxScrollExtent;
      final currentScroll = _controller.position.pixels;
      const threshold = 200.0;

      AppLogger.info('Current Scroll: $currentScroll, Max Scroll: $maxScroll');
      AppLogger.info('Threshold: $threshold');
      if (currentScroll >= maxScroll - threshold) {
        AppLogger.info('Loading more items...');
        if (widget.hasMore && !widget.isLoadingMore) {
          widget.onLoadMore();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount =
        widget.items.length + (widget.isLoadingMore && widget.hasMore ? 1 : 0);

    return ListView.separated(
      shrinkWrap: true,
      controller: _controller,
      scrollDirection: widget.scrollDirection,
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
