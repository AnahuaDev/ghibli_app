class Movie {
  static String table = "Movies";
  String id;
  String title;
  String description;
  String director;
  String producer;
  String releaseDate;
  String rating;
  String image;
  String movie_banner;
  String original_title_romanised;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.director,
    required this.producer,
    required this.releaseDate,
    required this.rating,
    required this.image,
    required this.movie_banner,
    required this.original_title_romanised,
  });

  Movie.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        director = json['director'],
        producer = json['producer'],
        releaseDate = json['release_date'],
        rating = json['rt_score'],
        image = json['image'],
        movie_banner = json["movie_banner"],
        original_title_romanised = json["original_title_romanised"];
}
