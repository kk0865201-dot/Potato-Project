/// A page of results plus the pagination info from the API `meta` block.
class Paginated<T> {
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;

  const Paginated({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;

  factory Paginated.fromMeta(
    List<T> items,
    Map<String, dynamic>? meta,
  ) {
    return Paginated(
      items: items,
      currentPage: meta?['current_page'] as int? ?? 1,
      lastPage: meta?['last_page'] as int? ?? 1,
      total: meta?['total'] as int? ?? items.length,
    );
  }
}
