import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:zaki_movie_apps/Models/PopularMovies.dart';
import 'package:zaki_movie_apps/Models/TvShow.dart';
import 'package:zaki_movie_apps/Screens/disconnect.dart';
import 'package:zaki_movie_apps/Services/API.dart';
import 'package:zaki_movie_apps/Services/consts.dart';
import 'package:zaki_movie_apps/Widgets/BottomNavBar.dart';
import 'package:zaki_movie_apps/Widgets/CarouselCard.dart';
import 'package:zaki_movie_apps/Widgets/CustomLists.dart';
import 'package:zaki_movie_apps/Widgets/LoadingScreen.dart';
import 'package:zaki_movie_apps/Widgets/SectionText.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:zaki_movie_apps/Widgets/disconnect.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ScrollController _scrollController = ScrollController();

  bool isVisible = true;
  late List<Results> popularMovie;
  late List<Results> popularMovieloader;
  late List<Results> topRatedMovie;
  late List<Results> topRatedMovieloader;
  late List<Results> nowPLayingMovie;
  late List<Results> nowPlayMovieloader;
  late List<TvShow> popularShows;
  late List<TvShow> popularShowsloader;
  late List<TvShow> topRatedShows;
  bool isLoading = true;
  ScrollController _popularmovie = ScrollController();
  ScrollController _nowplayingmovie = ScrollController();
  ScrollController _topratedmovie = ScrollController();
  ScrollController _popularshows = ScrollController();
  int popularPage = 1;
  int topratedPage = 1;
  int nowplayPage = 1;
  int popularshowPage = 1;
  bool isLoadingMorePopular = false;
  bool isLoadingMoreTopRated = false;
  bool isLoadingMoreNowPlay = false;
  bool isLoadingPopularShows = false;
  String? controller;
  bool initial = true;
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();
  dynamic subscription;
  bool isConnected = true;

  void checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        initial = false;
        isConnected = true;
      });
    } else {
      setState(() {
        isConnected == false;
      });
      fetchData();
    }
    checkConnectionChange();
  }

  checkConnectionChange() {
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
          setState(() {
            isConnected == false;
          });
          fetchData();
        }
      } else {
        setState(() {
          isConnected = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkConnection();
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(listen);

    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        connectivityResult = result;
      });
    });

    _popularmovie.addListener(() {
      if (_popularmovie.position.pixels ==
          _popularmovie.position.maxScrollExtent) {
        setState(() {
          controller = 'popular';
          lazyLoad();
        });
      }
    });

    _topratedmovie.addListener(() {
      if (_topratedmovie.position.pixels ==
          _topratedmovie.position.maxScrollExtent) {
        setState(() {
          controller = 'top_rated';
          lazyLoad();
        });
      }
    });

    _nowplayingmovie.addListener(() {
      if (_nowplayingmovie.position.pixels ==
          _nowplayingmovie.position.maxScrollExtent) {
        setState(() {
          controller = 'now_playing';
          lazyLoad();
        });
      }
    });

    _popularshows.addListener(() {
      if (_popularshows.position.pixels ==
          _popularshows.position.maxScrollExtent) {
        setState(() {
          controller = 'popular_show';
          lazyLoad();
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(listen);
    _scrollController.dispose();
    super.dispose();
    subscription.cancel();
  }

  void listen() {
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }

  Future<void> lazyLoad() async {
    if (controller == 'popular') {
      setState(() {
        isLoadingMorePopular = true;
      });
      popularPage = popularPage + 1;
      popularMovieloader = await APIService().getPopularMovie(popularPage);
      popularMovie.addAll(popularMovieloader);
      setState(() {
        isLoadingMorePopular = false;
      });
    } else if (controller == 'top_rated') {
      setState(() {
        isLoadingMoreTopRated = true;
      });
      topratedPage = topratedPage + 1;
      topRatedMovieloader = await APIService().getTopRatedMovie(topratedPage);
      topRatedMovie.addAll(topRatedMovieloader);
      setState(() {
        isLoadingMoreTopRated = false;
      });
    } else if (controller == 'now_playing') {
      setState(() {
        isLoadingMoreNowPlay = true;
      });
      nowplayPage = nowplayPage + 1;
      nowPlayMovieloader = await APIService().getNowPLayingMovie(nowplayPage);
      nowPLayingMovie.addAll(nowPlayMovieloader);
      setState(() {
        isLoadingMoreNowPlay = false;
      });
    } else if (controller == 'popular_show') {
      setState(() {
        isLoadingPopularShows = true;
      });
      popularshowPage = popularshowPage + 1;
      popularShowsloader =
          await APIService().getRecommendedTvShows("1991", popularshowPage);
      popularShows.addAll(popularShowsloader);
      // print(popularshowPage);
      setState(() {
        isLoadingPopularShows = false;
      });
    }
  }

  void show() {
    if (!isVisible) {
      (setState(
        () => isVisible = true,
      ));
    }
  }

  void hide() {
    if (isVisible) {
      (setState(
        () => isVisible = false,
      ));
    }
  }

  Future<void> fetchData() async {
    topRatedShows = await APIService().getTopRatedShow();
    popularMovie = await APIService().getPopularMovie(popularPage);
    topRatedMovie = await APIService().getTopRatedMovie(topratedPage);
    popularShows =
        await APIService().getRecommendedTvShows("1991", popularshowPage);
    nowPLayingMovie = await APIService().getNowPLayingMovie(nowplayPage);
    setState(() {
      isLoading = false;
      isConnected = false;
    });
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: AnimatedBuilder(
          animation: _scrollController,
          builder: ((context, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.fastLinearToSlowEaseIn,
              height: isVisible ? 75 : 0,
              child: BottomNavBar(
                currentIndex: 0,
              ),
            );
          })),
      extendBody: true,
      body: isLoading
          ? LoadingScreen()
          : isConnected
              ? Disconnect()
              : Container(
                  height: size.height,
                  width: size.width,
                  color: background_primary,
                  child: RefreshIndicator(
                    onRefresh: lazyLoad,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      controller: _scrollController,
                      shrinkWrap: true,
                      children: [
                        CustomCarouselSlider(topRatedShows),
                        SectionText("Popular", "Movies"),
                        CustomListMovie(popularMovie, _popularmovie),
                        if (isLoadingMorePopular)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Image.asset(
                              'assets/load.gif',
                              width: 40,
                            )),
                          ),
                        SectionText("TOP Rated", "Movies"),
                        CustomListMovie(topRatedMovie, _topratedmovie),
                        if (isLoadingMoreTopRated)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Image.asset(
                              'assets/load.gif',
                              width: 40,
                            )),
                          ),
                        SectionText("NoW Playing", "Movies"),
                        CustomListMovie(nowPLayingMovie, _nowplayingmovie),
                        if (isLoadingMoreNowPlay)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Image.asset(
                              'assets/load.gif',
                              width: 40,
                            )),
                          ),
                        SectionText("Popular", "TV Shows"),
                        CustomListTV(popularShows, _popularshows),
                        if (isLoadingPopularShows)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Image.asset(
                              'assets/load.gif',
                              width: 40,
                            )),
                          ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
