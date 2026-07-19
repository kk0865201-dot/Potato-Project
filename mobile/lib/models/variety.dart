/// A potato variety coming from the Laravel API (`/api/v1/varieties`).
class Variety {
  final int id;
  final String slug;
  final String name;
  final String type;
  final String description;
  final String bestFor;
  final String? origin;
  final double rating;
  final String imageUrl;
  final String imageAlt;
  final bool featured;

  const Variety({
    required this.id,
    required this.slug,
    required this.name,
    required this.type,
    required this.description,
    required this.bestFor,
    this.origin,
    required this.rating,
    required this.imageUrl,
    required this.imageAlt,
    required this.featured,
  });

  factory Variety.fromJson(Map<String, dynamic> json) {
    return Variety(
      id: json['id'] as int,
      slug: json['slug'] as String,
      name: json['name'] as String,
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      bestFor: json['best_for'] as String? ?? '',
      origin: json['origin'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      imageUrl: json['image_url'] as String? ?? '',
      imageAlt: json['image_alt'] as String? ?? '',
      featured: json['featured'] as bool? ?? false,
    );
  }
}
