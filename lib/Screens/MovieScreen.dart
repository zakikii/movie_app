import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zaki_movie_apps/Models/PopularMovies.dart';
import 'package:zaki_movie_apps/Services/API.dart';
import 'package:zaki_movie_apps/Services/consts.dart';
import 'package:zaki_movie_apps/Widgets/CustomLists.dart';
import 'package:zaki_movie_apps/Widgets/LoadingScreen.dart';
import 'package:unicons/unicons.dart';
import 'package:zaki_movie_apps/Services/extraServices.dart';
import 'package:zaki_movie_apps/Widgets/DetailScreenComponents.dart';
import 'package:zaki_movie_apps/Widgets/disconnect.dart';

class MovieScreen extends StatefulWidget {
  MovieScreen(this.movieId, {super.key});
  String movieId;

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  bool isLoading = true;
  late List<Results> recommendedMovies;
  final ScrollController _recommended = ScrollController();
  dynamic subscription;
  bool initial = true;
  bool isConnecting = true;

  Future<void> fetchData() async {
    recommendedMovies = await APIService().getRecommendedMovie(widget.movieId);
    setState(() {
      isLoading = false;
      isConnecting = false;
    });
  }

  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        initial = false;
        isConnecting = true;
      });
    } else {
      fetchData();
      setState(() {
        isConnecting == false;
      });
    }
    checkConnectionChange();
  }

  void checkConnectionChange() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print("RESULT : $initial");
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        if (initial) {
          setState(() {
            initial = false;
          });
        } else {
          fetchData();
          setState(() {
            isConnecting == false;
          });
        }
      } else {
        setState(() {
          isConnecting = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkConnection();
    super.initState();
    // fetchData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: background_primary,
      body: isLoading
          ? LoadingScreen()
          : isConnecting
              ? Disconnect()
              : FutureBuilder(
                  future: APIService().getMovieDetail(widget.movieId),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var status = snapshot.data!.status.toString();
                      var releaseDate = snapshot.data!.releaseDate.toString();
                      return ListView(
                          scrollDirection: Axis.vertical,
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: size.width,
                                  height: size.height * 0.40 > 300
                                      ? size.height * 0.40
                                      : 300,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: snapshot.data!.backdropPath == null
                                          ? const AssetImage("assets/load.gif")
                                          : NetworkImage(
                                              "https://image.tmdb.org/t/p/original${snapshot.data!.backdropPath}",
                                            ) as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width,
                                  height: size.height * 0.40 > 300
                                      ? size.height * 0.40
                                      : 300,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent,
                                          background_primary.withOpacity(0.50),
                                          background_primary.withOpacity(0.75),
                                          background_primary.withOpacity(0.90),
                                          background_primary.withOpacity(1.00),
                                        ]),
                                  ),
                                ),
                                Container(
                                  width: size.width,
                                  height: size.height * 0.35 > 300
                                      ? size.height * 0.35
                                      : 300,
                                  margin: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        snapshot.data!.voteAverage
                                            .toString()
                                            .substring(0, 3),
                                        style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        snapshot.data!.title.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      Row(
                                        children: [
                                          CircularButtons(
                                            UniconsLine.play,
                                            onTap: () {
                                              HapticFeedback.lightImpact();
                                              APIService()
                                                  .getTrailerLink(
                                                      snapshot.data!.id
                                                          .toString(),
                                                      "movie")
                                                  .then((value) =>
                                                      LaunchUrl(value));
                                            },
                                          ),
                                          CircularButtons(
                                            UniconsLine.plus,
                                            onTap: () {
                                              HapticFeedback.lightImpact();
                                              pshowDialog(context,
                                                  widget.movieId, "movie");
                                            },
                                          ),
                                          Visibility(
                                            visible: snapshot.data!.adult,
                                            child: CircularButtons(
                                              UniconsLine.eighteen_plus,
                                              onTap: () {},
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            FutureBuilder(
                              future: APIService()
                                  .getMovieGenres(widget.movieId, "movie"),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    height: 36,
                                    width: size.width,
                                    margin: const EdgeInsets.only(left: 8),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return TextContainer(
                                            snapshot.data![index].name
                                                .toString(),
                                            const EdgeInsets.only(right: 8),
                                            const Color(0xFF14303B));
                                      },
                                    ),
                                  );
                                } else {
                                  return TextContainer(
                                      "Loading",
                                      const EdgeInsets.all(8),
                                      const Color(0xFF14303B));
                                }
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleText("Status"),
                                Row(
                                  children: [
                                    TextContainer(
                                        status,
                                        const EdgeInsets.only(
                                            left: 8, right: 8, bottom: 8),
                                        const Color(0xFF382E39)),
                                    TextContainer(
                                        "Release: ${DateFormat.yMMMMd().format(DateTime.parse(releaseDate))}",
                                        const EdgeInsets.only(
                                            left: 8, right: 8, bottom: 8),
                                        const Color(0xFF545551)),
                                  ],
                                ),
                                TitleText("Overview"),
                                TextContainer(
                                    snapshot.data!.overview
                                                .toString()
                                                .isEmpty ||
                                            snapshot.data!.overview
                                                    .toString() ==
                                                "null"
                                        ? "No overview available"
                                        : snapshot.data!.overview.toString(),
                                    const EdgeInsets.all(8),
                                    const Color(0xFF0F1D39)),
                                TitleText("Recommendations"),
                                CustomListMovie(
                                    recommendedMovies, _recommended),
                              ],
                            )
                          ]);
                    } else {
                      return const LoadingScreen();
                    }
                  },
                ),
    );
  }
}
