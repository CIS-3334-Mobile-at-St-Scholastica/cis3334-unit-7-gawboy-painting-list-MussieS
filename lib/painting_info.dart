class PaintingInfo {
  String name;
  String description; // general description (optional)
  String imageFile;

  // Carl Gawboy-specific fields (used for this assignment)
  String gawboyDescription;

  // Sometimes the data uses category/catagory
  String category;

  PaintingInfo({
    required this.name,
    required this.description,
    required this.imageFile,
    required this.gawboyDescription,
    required this.category,
  });

  // Robust JSON parsing: supports several possible key spellings
  factory PaintingInfo.fromJson(dynamic json) {
    final Map<String, dynamic> m =
    (json is Map<String, dynamic>) ? json : <String, dynamic>{};

    String readString(String key, {String fallback = ''}) {
      final v = m[key];
      if (v == null) return fallback;
      return v.toString();
    }

    final name = readString(
      'name',
      fallback: readString('title', fallback: readString('paintingName')),
    );

    final description = readString('description');

    final gawboyDescription = readString(
      'gawboyDescription',
      fallback: readString('gawboy_description', fallback: description),
    );

    final imageFile = readString(
      'imageFile',
      fallback: readString(
        'image_file',
        fallback: readString('image', fallback: readString('file')),
      ),
    );

    // common misspelling in some class samples: "catagory"
    final category = readString('category', fallback: readString('catagory'));

    return PaintingInfo(
      name: name,
      description: description,
      imageFile: imageFile,
      gawboyDescription: gawboyDescription,
      category: category,
    );
  }

  // Helper to decide if this painting is by/for Carl Gawboy
  bool get isGawboy {
    final c = category.toLowerCase();
    if (c.isEmpty) return false;
    return c.contains('gawboy') || c.contains('carl gawboy');
  }
}
