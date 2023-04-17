import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  Future<List<MovieInfo>> moviesPopular = ApiService.getPopularMovie();
  Future<List<MovieInfo>> moviesNowPlay = ApiService.getNowMovie();
  Future<List<MovieInfo>> movieSoon = ApiService.getSoonMovie();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 280,
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Popular Movies',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: moviesPopular,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          flex: 1,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var movie = snapshot.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) => DetailPage(
                                              id: movie.id.toString()),
                                        ));
                                  },
                                  child: Hero(
                                    tag: movie.id.toString(),
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: SizedBox(
                                            width: 400,
                                            child: Image.network(
                                              movie.posterPath,
                                              fit: BoxFit.cover,
                                            ))),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    width: 20,
                                    height: 10,
                                  ),
                              itemCount: snapshot.data!.length),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 280,
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'Now In Cinemas',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: moviesNowPlay,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          flex: 1,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var movie = snapshot.data![index];
                                return Column(
                                  children: [
                                    SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailPage(
                                                            id: movie.id
                                                                .toString()),
                                                    fullscreenDialog: true));
                                          },
                                          child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              child: Image.network(
                                                movie.posterPath,
                                                fit: BoxFit.none,
                                              )),
                                        )),
                                    Text(
                                      movie.title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    )
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    width: 20,
                                    height: 10,
                                  ),
                              itemCount: snapshot.data!.length),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              height: 300,
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'Coming Soon',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: movieSoon,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Expanded(
                          flex: 1,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var movie = snapshot.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                              id: movie.id.toString()),
                                        ));
                                  },
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                      child: Image.network(movie.posterPath)),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    width: 20,
                                    height: 10,
                                  ),
                              itemCount: snapshot.data!.length),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

//디테일 페이지

class DetailPage extends StatelessWidget {
  final String id;
  final Future<MovieDetail> movie;
  DetailPage({Key? key, required this.id})
      : movie = ApiService.getMovieId(id),
        super(key: key);

  void onClick() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Back To The List'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              FutureBuilder(
                future: movie,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var selectedMovie = snapshot.data;
                    return Hero(
                      transitionOnUserGestures: true,
                      tag: id,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 920,
                            child: Opacity(
                              opacity: 1,
                              child: ColorFiltered(
                                colorFilter: const ColorFilter.matrix([
                                  0.5,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0.5,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0.5,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  1,
                                  0,
                                ]),
                                child: Image.network(
                                  selectedMovie!.backdroppath.toString(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 300,
                                  ),
                                  Text(
                                    selectedMovie.title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  RatingBar(
                                    initialRating:
                                        selectedMovie.voteaverage / 2,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    ratingWidget: RatingWidget(
                                      full: Icon(
                                        Icons.star,
                                        color: Colors.amber.shade400,
                                      ),
                                      half: Icon(
                                        Icons.star_half,
                                        color: Colors.amber.shade400,
                                      ),
                                      empty: Icon(
                                        Icons.star_border,
                                        color: Colors.amber.shade400,
                                      ),
                                    ),
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${selectedMovie.releasedate} | ${selectedMovie.runtime ~/ 60} hour ${selectedMovie.runtime % 60} minute\n${selectedMovie.genres}',
                                    style: const TextStyle(
                                        color: Colors.white60, fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Storyline',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    selectedMovie.overview,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: onClick,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.amber.shade300,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10))),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50,
                                                      vertical: 10),
                                              child: const Text(
                                                'Buy Ticket',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ));
  }
}

//API 서버에서 받아온 JOSN 파싱
class ApiService {
  //URI 부분
  static const String baseUrl = "https://movies-api.nomadcoders.workers.dev";
  static const String imgUrl = "https://image.tmdb.org/t/p/w500";
  static const String getMovieIdUrl = "movie?id=";
  static const String popular = "popular";
  static const String nowPlay = "now-playing";
  static const String soon = "coming-soon";

  static Future<List<MovieInfo>> getPopularMovie() async {
    List<MovieInfo> movieInfo = [];
    final url = Uri.parse('$baseUrl/$popular');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> moviesJason = jsonDecode(response.body);
      final List<dynamic> movies = moviesJason['results'];
      //data.map((movies) => MovieInfo.fromJson(movies)).toList();
      for (var movie in movies) {
        movieInfo.add(MovieInfo.fromJson(movie));
      }
    }
    return movieInfo;
  }

  static Future<List<MovieInfo>> getNowMovie() async {
    List<MovieInfo> movieInfo = [];
    final url = Uri.parse('$baseUrl/$nowPlay');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> movies = jsonDecode(response.body)['results'];
      for (var movie in movies) {
        movieInfo.add(MovieInfo.fromJson(movie));
      }
    }
    return movieInfo;
  }

  static Future<List<MovieInfo>> getSoonMovie() async {
    List<MovieInfo> movieInfo = [];
    final url = Uri.parse('$baseUrl/$soon');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> movieJson = jsonDecode(response.body);
      final List<dynamic> movies = movieJson['results'];
      for (var movie in movies) {
        movieInfo.add(MovieInfo.fromJson(movie));
      }
    }
    return movieInfo;
  }

  static Future<MovieDetail> getMovieId(String id) async {
    final url = Uri.parse('$baseUrl/$getMovieIdUrl$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> movieJson = jsonDecode(response.body);
      return MovieDetail.fromJson(movieJson);
    }
    throw Exception("Failed to get movie info");
  }
}

//JSON(영화정보 데이터) 파싱할 객체
class MovieInfo {
  final int id; //id
  final String title; //제목
  final String posterPath; //포스터 경로

  MovieInfo({
    required this.id,
    required this.title,
    required this.posterPath,
  });

  factory MovieInfo.fromJson(Map<String, dynamic> json) {
    return MovieInfo(
      id: json['id'],
      title: json['title'],
      posterPath: "https://image.tmdb.org/t/p/w500/${json['poster_path']}",
    );
  }
}

class MovieDetail {
  final int id; //id
  final String title; //제목
  final String backdroppath; //포스터 경로
  final String overview; //영화 개요
  final double voteaverage; //영화 평점
  final String releasedate; //개봉일
  final int runtime;
  final String genres;

  MovieDetail(
      {required this.id,
      required this.title,
      required this.backdroppath,
      required this.overview,
      required this.voteaverage,
      required this.releasedate,
      required this.runtime,
      required this.genres});

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
        id: json['id'],
        title: json['title'],
        backdroppath: "https://image.tmdb.org/t/p/w500${json['backdrop_path']}",
        overview: json['overview'],
        voteaverage: json['vote_average'],
        releasedate: json['release_date'],
        runtime: json['runtime'],
        genres: getGenres(json['genres']));
  }

  static String getGenres(List<dynamic> json) {
    List<String> genreName = [];
    for (int i = 0; i < json.length; i++) {
      genreName.add(json[i]['name']);
    }
    return genreName.join(", ");
  }
}
