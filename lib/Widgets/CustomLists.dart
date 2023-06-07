import 'package:flutter/material.dart';
import 'package:zaki_movie_apps/Models/PopularMovies.dart';
import 'package:zaki_movie_apps/Models/TvShow.dart';
import 'package:zaki_movie_apps/Widgets/MovieCard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class CustomListMovie extends StatefulWidget {
  CustomListMovie(this.data, this.controller, {super.key});
  List<Results> data;
  ScrollController controller;

  @override
  State<CustomListMovie> createState() => _CustomListMovieState();
}

class _CustomListMovieState extends State<CustomListMovie> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        shrinkWrap: true,
        controller: widget.controller,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.data.length,
        cacheExtent: 9999,
        itemBuilder: ((context, index) {
          var url = widget.data[index].posterPath.toString();
          return KeyedSubtree(
              key: UniqueKey(),
              child: MovieCard(
                  widget.data[index].title.toString(),
                  CachedNetworkImageProvider(
                      "https://image.tmdb.org/t/p/w500$url"),
                  widget.data[index].id.toString(),
                  "movie"));
        }),
      ),
    );
  }
}

class CustomListTV extends StatefulWidget {
  CustomListTV(this.data, this.controller, {super.key});
  List<TvShow> data;
  ScrollController controller;

  @override
  State<CustomListTV> createState() => _CustomListTVState();
}

class _CustomListTVState extends State<CustomListTV> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: ListView.builder(
          shrinkWrap: true,
          controller: widget.controller,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.data.length,
          itemBuilder: ((context, index) {
            var url = widget.data[index].posterPath.toString();
            return KeyedSubtree(
                key: UniqueKey(),
                child: MovieCard(
                    widget.data[index].name.toString(),
                    NetworkImage("https://image.tmdb.org/t/p/w500$url"),
                    widget.data[index].id.toString(),
                    "tv"));
          }),
        ));
  }
}

class RecommendedCustomListTV extends StatefulWidget {
  RecommendedCustomListTV(this.data, {super.key});
  List<TvShow> data;

  @override
  State<RecommendedCustomListTV> createState() =>
      _RecommendedCustomListTVState();
}

class _RecommendedCustomListTVState extends State<RecommendedCustomListTV>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.data.length > 20 ? 20 : widget.data.length,
          itemBuilder: ((context, index) {
            var url = widget.data[index].posterPath.toString();
            return KeyedSubtree(
                key: UniqueKey(),
                child: MovieCard(
                    widget.data[index].name.toString(),
                    NetworkImage("https://image.tmdb.org/t/p/w500$url"),
                    widget.data[index].id.toString(),
                    "tv"));
          }),
        ));
  }
}
