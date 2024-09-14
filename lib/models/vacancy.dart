class Vacancy {
  final String? id;
  final String? title;
  final String? company;
  final String? location;
  final String? description;
  final String? longDescription;
  final String? salary;
  final String? datePosted;
  final String? imageUrl;

  Vacancy({
    this.id,
    this.title,
    this.company,
    this.location,
    this.description,
    this.longDescription,
    this.salary,
    this.datePosted,
    this.imageUrl,
  });

  // Factory constructor to create a Vacancy object from JSON
  factory Vacancy.fromJson(Map<String, dynamic> json) {
    return Vacancy(
      id: json['id'] as String?,
      title: json['title'] as String?,
      company: json['company'] as String?,
      location: json['location'] as String?,
      description: json['description'] as String?,
      longDescription: json['long_description'] as String?,
      salary: json['salary'] as String?,
      datePosted: json['date_posted'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
}
