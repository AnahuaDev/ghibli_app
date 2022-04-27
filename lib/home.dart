import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:expandable_text/expandable_text.dart';
import 'Models/Movie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: moviePoster(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromRGBO(0, 128, 188, 1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // ignore: prefer_const_constructors
                      SizedBox(
                        height: 200.0,
                        width: 200.0,
                        child: const Image(
                          image: AssetImage("images/totoro_gif.gif"),
                        ),
                      ),
                      // const CircularProgressIndicator(),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text("Looking for your best option...",
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                color: const Color.fromRGBO(178, 215, 232, 1))),
                      )
                    ],
                  ),
                ),
              );
            } else {
              if (snapshot.hasError) {
                return Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Center(child: Text('Error: ${snapshot.error}')));
              } else {
                return snapshot.data as Widget;
              }
            }
          }),
    );
  }

  Future<Widget> moviePoster() async {
    Movie movie = await getRandomMovie();
    return Stack(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(movie.movie_banner),
                    fit: BoxFit.cover))),
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    const Color.fromRGBO(0, 128, 188, 1),
                  ],
                  // ignore: prefer_const_literals_to_create_immutables
                  stops: [
                    0,
                    1.0
                  ])),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        width: 200.0,
                        height: 200.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(movie.image))),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                                movie.title + " (" + movie.releaseDate + ")",
                                style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromRGBO(
                                        178, 215, 232, 1))),
                          ),
                          Container(
                            child: Text(movie.original_title_romanised,
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: const Color.fromRGBO(
                                        178, 215, 232, 1))),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.movie_creation_outlined,
                                  size: 16.0,
                                  color:
                                      const Color.fromRGBO(178, 215, 232, 1)),
                              Flexible(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10.0),
                                  child: Text(movie.director,
                                      style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: const Color.fromRGBO(
                                              178, 215, 232, 1))),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.movie_filter_outlined,
                                  size: 16.0,
                                  color:
                                      const Color.fromRGBO(178, 215, 232, 1)),
                              Flexible(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10.0),
                                  child: Text(movie.producer,
                                      maxLines: 2,
                                      style: GoogleFonts.lato(
                                          fontSize: 15,
                                          color: const Color.fromRGBO(
                                              178, 215, 232, 1))),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: RatingBar(
                              itemSize: 25.0,
                              initialRating:
                                  double.parse(movie.rating) * 5 / 100,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              ignoreGestures: true,
                              ratingWidget: RatingWidget(
                                  full: Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  half: Icon(
                                    Icons.star_half,
                                    color: Colors.amber,
                                  ),
                                  empty: Icon(
                                    Icons.star_border,
                                    color: Colors.amber,
                                  )),
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 1.0),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ),
                          Container(
                            child: TextButton(
                              child: Text("Add to favorites"),
                              onPressed: () {
                                print("favorite");
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: ExpandableText(movie.description,
                    expandText: 'show more',
                    collapseText: 'show less',
                    maxLines: 10,
                    linkColor: Colors.grey[900],
                    animation: true,
                    style: GoogleFonts.lato(
                        fontSize: 16,
                        color: const Color.fromRGBO(178, 215, 232, 1))),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => HomePage()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Text(
                    "Give me another option",
                    style: GoogleFonts.lato(
                        fontSize: 13, color: Color.fromRGBO(178, 215, 232, 1)),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 5.0),
                    // ignore: prefer_const_constructors
                    child: Icon(
                      Icons.refresh,
                      size: 15.0,
                      color: const Color.fromRGBO(178, 215, 232, 1),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<Movie> getRandomMovie() async {
    await Future.delayed(Duration(seconds: 2));
    final httpsUri = Uri(
      scheme: 'https',
      host: 'ghibliapi.herokuapp.com',
      path: 'films',
    );
    var response = await http.get(httpsUri);
    List body = json.decode(response.body);

    if (response.statusCode == 200) {
      Random random = Random();
      int index = random.nextInt(body.length);

      return Movie.fromJson(body[index]);
    } else {
      throw ApiException(response.statusCode, {
        'message': 'somethings went wrong',
        'body': json.decode(response.body),
      });
    }
  }
}

class ApiException implements Exception {
  int statusCode;
  dynamic data;

  ApiException(this.statusCode, this.data);
}
