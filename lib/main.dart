import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MovieHomePage(),
    );
  }
}

class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key});

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

//위젯 작성
class _MovieHomePageState extends State<MovieHomePage> {
  Future<List<MovieInfo>> movies = ApiService.getMovieInfo();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
      child: FutureBuilder(
        future: movies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Popular Movies',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 1,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var movie = snapshot.data![index];
                        return Container(
                            width: 150,
                            height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            child: Column(
                              children: [
                                Image.network(
                                  movie.posterPath,
                                  fit: BoxFit.fitHeight,
                                ),
                                Text(
                                  movie.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              ],
                            ));
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            width: 20,
                            height: 10,
                          ),
                      itemCount: snapshot.data!.length),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ));
  }
}

//API 서버에서 받아온 JOSN 파싱
class ApiService {
  //URI 부분
  static const String baseUrl = "https://movies-api.nomadcoders.workers.dev";
  static const String imgUrl = "https://image.tmdb.org/t/p/w500";
  static const String popular = "popular";
  static const String nowPlay = "now-playing";
  static const String soon = "coming-soon";

  static Future<List<MovieInfo>> getMovieInfo() async {
    List<MovieInfo> movieInfo = [];
    final url = Uri.parse('$baseUrl/$popular');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> movies = jsonDecode(response.body)['results'];
      //data.map((movies) => MovieInfo.fromJson(movies)).toList();
      for (var movie in movies) {
        movieInfo.add(MovieInfo.fromJson(movie));
      }
    }
    return movieInfo;
  }
}

//JSON(영화정보 데이터) 파싱할 객체
class MovieInfo {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final double voteAverage;
  final String releaseDate;

  MovieInfo({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory MovieInfo.fromJson(Map<String, dynamic> json) {
    return MovieInfo(
      id: json['id'],
      title: json['title'],
      posterPath: "https://image.tmdb.org/t/p/w500/${json['poster_path']}",
      overview: json['overview'],
      voteAverage: json['vote_average'].toDouble(),
      releaseDate: json['release_date'],
    );
  }
}

// Model Class
class MovieModel {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  MovieModel(
      this.adult,
      this.backdropPath,
      this.genreIds,
      this.id,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.releaseDate,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount);

  String getFullPosterPath() {
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String getFullBackdropPath() {
    return 'https://image.tmdb.org/t/p/w500$backdropPath';
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        json['adult'] as bool,
        json['backdrop_path'] as String?,
        (json['genre_ids'] as List<dynamic>).map((e) => e as int).toList(),
        json['id'] as int,
        json['original_language'] as String,
        json['original_title'] as String,
        json['overview'] as String,
        (json['popularity'] as num).toDouble(),
        json['poster_path'] as String,
        json['release_date'] as String,
        json['title'] as String,
        json['video'] as bool,
        (json['vote_average'] as num).toDouble(),
        json['vote_count'] as int,
      );

  Map<String, dynamic> toJson(MovieModel instance) => {
        'adult': instance.adult,
        'backdrop_path': instance.backdropPath,
        'genre_ids': instance.genreIds,
        'id': instance.id,
        'original_language': instance.originalLanguage,
        'original_title': instance.originalTitle,
        'overview': instance.overview,
        'popularity': instance.popularity,
        'poster_path': instance.posterPath,
        'release_date': instance.releaseDate,
        'title': instance.title,
        'video': instance.video,
        'vote_average': instance.voteAverage,
        'vote_count': instance.voteCount,
      };
}

class MovieDetailModel {
  final bool adult;
  final String backdropPath;
  final BelongToCollection? belongsToCollection;
  final int budget;
  final List<Genres> genres;
  final String homepage;
  final int id;
  final String imdbId;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<ProductionCompanies> productionCompanies;
  final List<ProductionCountries> productionCountries;
  final String releaseDate;
  final int revenue;
  final int runtime;
  final List<SpokenLanguages> spokenLanguages;
  final String status;
  final String tagline;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  MovieDetailModel(
      this.adult,
      this.backdropPath,
      this.belongsToCollection,
      this.budget,
      this.genres,
      this.homepage,
      this.id,
      this.imdbId,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.productionCompanies,
      this.productionCountries,
      this.releaseDate,
      this.revenue,
      this.runtime,
      this.spokenLanguages,
      this.status,
      this.tagline,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount);

  String get getFullPosterPath {
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get getFullBackdropPath {
    return 'https://image.tmdb.org/t/p/w500$backdropPath';
  }

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      MovieDetailModel(
        json['adult'] as bool,
        json['backdrop_path'] as String,
        json['belongs_to_collection'] == null
            ? null
            : BelongToCollection.fromJson(
                json['belongs_to_collection'] as Map<String, dynamic>),
        json['budget'] as int,
        (json['genres'] as List<dynamic>)
            .map((e) => Genres.fromJson(e as Map<String, dynamic>))
            .toList(),
        json['homepage'] as String,
        json['id'] as int,
        json['imdb_id'] as String,
        json['original_language'] as String,
        json['original_title'] as String,
        json['overview'] as String,
        (json['popularity'] as num).toDouble(),
        json['poster_path'] as String,
        (json['production_companies'] as List<dynamic>)
            .map((e) => ProductionCompanies.fromJson(e as Map<String, dynamic>))
            .toList(),
        (json['production_countries'] as List<dynamic>)
            .map((e) => ProductionCountries.fromJson(e as Map<String, dynamic>))
            .toList(),
        json['release_date'] as String,
        json['revenue'] as int,
        json['runtime'] as int,
        (json['spoken_languages'] as List<dynamic>)
            .map((e) => SpokenLanguages.fromJson(e as Map<String, dynamic>))
            .toList(),
        json['status'] as String,
        json['tagline'] as String,
        json['title'] as String,
        json['video'] as bool,
        (json['vote_average'] as num).toDouble(),
        json['vote_count'] as int,
      );

  Map<String, dynamic> toJson(MovieDetailModel instance) => {
        'adult': instance.adult,
        'backdrop_path': instance.backdropPath,
        'belongs_to_collection': instance.belongsToCollection,
        'budget': instance.budget,
        'genres': instance.genres,
        'homepage': instance.homepage,
        'id': instance.id,
        'imdb_id': instance.imdbId,
        'original_language': instance.originalLanguage,
        'original_title': instance.originalTitle,
        'overview': instance.overview,
        'popularity': instance.popularity,
        'poster_path': instance.posterPath,
        'production_companies': instance.productionCompanies,
        'production_countries': instance.productionCountries,
        'release_date': instance.releaseDate,
        'revenue': instance.revenue,
        'runtime': instance.runtime,
        'spoken_languages': instance.spokenLanguages,
        'status': instance.status,
        'tagline': instance.tagline,
        'title': instance.title,
        'video': instance.video,
        'vote_average': instance.voteAverage,
        'vote_count': instance.voteCount,
      };
}

class BelongToCollection {
  final int id;
  final String name;
  final String? posterPath;
  final String? backdropPath;

  BelongToCollection(this.id, this.name, this.posterPath, this.backdropPath);

  factory BelongToCollection.fromJson(Map<String, dynamic> json) =>
      BelongToCollection(
        json['id'] as int,
        json['name'] as String,
        json['poster_path'] as String?,
        json['backdrop_path'] as String?,
      );

  Map<String, dynamic> toJson(BelongToCollection instance) => {
        'id': instance.id,
        'name': instance.name,
        'poster_path': instance.posterPath,
        'backdrop_path': instance.backdropPath,
      };
}

class Genres {
  final int id;
  final String name;

  Genres(this.id, this.name);

  factory Genres.fromJson(Map<String, dynamic> json) => Genres(
        json['id'] as int,
        json['name'] as String,
      );

  Map<String, dynamic> toJson(Genres instance) => {
        'id': instance.id,
        'name': instance.name,
      };
}

class ProductionCompanies {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  ProductionCompanies(this.id, this.logoPath, this.name, this.originCountry);

  factory ProductionCompanies.fromJson(Map<String, dynamic> json) =>
      ProductionCompanies(
        json['id'] as int,
        json['logo_path'] as String?,
        json['name'] as String,
        json['origin_country'] as String,
      );
  Map<String, dynamic> toJson(ProductionCompanies instance) => {
        'id': instance.id,
        'logo_path': instance.logoPath,
        'name': instance.name,
        'origin_country': instance.originCountry,
      };
}

class ProductionCountries {
  final String iso31661;
  final String name;

  ProductionCountries(this.iso31661, this.name);

  factory ProductionCountries.fromJson(Map<String, dynamic> json) =>
      ProductionCountries(
        json['iso_3166_1'] as String,
        json['name'] as String,
      );
  Map<String, dynamic> toJson(ProductionCountries instance) => {
        'iso_3166_1': instance.iso31661,
        'name': instance.name,
      };
}

class SpokenLanguages {
  final String englishName;
  final String iso6391;
  final String name;

  SpokenLanguages(this.englishName, this.iso6391, this.name);

  factory SpokenLanguages.fromJson(Map<String, dynamic> json) =>
      SpokenLanguages(
        json['english_name'] as String,
        json['iso_639_1'] as String,
        json['name'] as String,
      );
  Map<String, dynamic> toJson(SpokenLanguages instance) => {
        'english_name': instance.englishName,
        'iso_639_1': instance.iso6391,
        'name': instance.name,
      };
}
