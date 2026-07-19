/// A recipe coming from the Laravel API (`/api/v1/recipes`).
class Recipe {
  final int id;
  final String slug;
  final String title;
  final String summary;
  final String tag;
  final int serves;
  final String prepTime;
  final String cookTime;
  final String bestPotato;
  final String imageUrl;
  final String imageAlt;
  final bool featured;
  final List<String> ingredients;
  final List<String> steps;

  const Recipe({
    required this.id,
    required this.slug,
    required this.title,
    required this.summary,
    required this.tag,
    required this.serves,
    required this.prepTime,
    required this.cookTime,
    required this.bestPotato,
    required this.imageUrl,
    required this.imageAlt,
    required this.featured,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      slug: json['slug'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String? ?? '',
      tag: json['tag'] as String? ?? '',
      serves: json['serves'] as int? ?? 0,
      prepTime: json['prep_time'] as String? ?? '',
      cookTime: json['cook_time'] as String? ?? '',
      bestPotato: json['best_potato'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      imageAlt: json['image_alt'] as String? ?? '',
      featured: json['featured'] as bool? ?? false,
      ingredients: (json['ingredients'] as List?)?.cast<String>() ?? const [],
      steps: (json['steps'] as List?)?.cast<String>() ?? const [],
    );
  }
}
