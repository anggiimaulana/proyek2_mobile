class PaginatedData<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool hasMorePages;

  PaginatedData({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.hasMorePages,
  });

  factory PaginatedData.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return PaginatedData<T>(
      data: (json['data'] as List).map((item) => fromJsonT(item)).toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      total: json['total'],
      hasMorePages: json['current_page'] < json['last_page'],
    );
  }
}
