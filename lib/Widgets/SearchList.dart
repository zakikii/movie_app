import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:zaki_movie_apps/Models/SearchResult.dart';
import 'package:zaki_movie_apps/Widgets/MovieCard.dart';
import 'package:zaki_movie_apps/Widgets/SearchCard.dart';

class SearchList extends StatefulWidget {
  SearchList(this.future, this.scrollController, {super.key});

  Future<List<SearchResult>> future;
  ScrollController scrollController;

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  double _scrollOffset = 0.0;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: widget.future,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: size.height * 0.8,
            child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              scrollDirection: Axis.vertical,
              controller: widget.scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (snapshot.data![index].mediaType == 'movie') {
                  var url = snapshot.data![index].posterPath;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      GoRouter.of(context)
                          .push('/movie/${snapshot.data![index].id}');
                    },
                    child: SearchCard(
                        snapshot.data![index].title.toString(),
                        url == null
                            ? const AssetImage("assets/404.gif")
                            : CachedNetworkImageProvider(
                                    "https://image.tmdb.org/t/p/original$url")
                                as ImageProvider,
                        snapshot.data![index].voteAverage.toString(),
                        'movie'),
                  );
                } else if (snapshot.data![index].mediaType == 'tv') {
                  var url = snapshot.data![index].posterPath;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      GoRouter.of(context)
                          .push('/tv/${snapshot.data![index].id}');
                    },
                    child: SearchCard(
                        snapshot.data![index].name.toString(),
                        url == null
                            ? const AssetImage("assets/404.gif")
                            : CachedNetworkImageProvider(
                                    "https://image.tmdb.org/t/p/original$url")
                                as ImageProvider,
                        snapshot.data![index].voteAverage.toString(),
                        'tv'),
                  );
                } else if (snapshot.data![index].mediaType == 'person') {
                  var url = snapshot.data![index].profilePath;
                  return SearchCard(
                      snapshot.data![index].name.toString(),
                      url == null
                          ? const AssetImage("assets/404.gif")
                          : CachedNetworkImageProvider(
                                  "https://image.tmdb.org/t/p/original$url")
                              as ImageProvider,
                      snapshot.data![index].popularity.toString(),
                      'person');
                } else {
                  return SearchCard("Loading",
                      const AssetImage("assets/404.gif"), "0", 'N/A');
                }
              },
            ),
          );
        } else {
          return SearchCard("Loading",
              const AssetImage("assets/LoadingImage.png"), "0", 'N/A');
        }
      },
    );
  }
}
