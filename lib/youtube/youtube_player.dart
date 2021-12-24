import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayer extends StatelessWidget {
  /*final _controllerHindi = YoutubePlayerController(
    initialVideoId: 'gjgaIVzHjA0',
    params: YoutubePlayerParams(
      playlist: ['gjgaIVzHjA0', 'q9jGrAkdnJU', 'kI9UIXLdxyk'],
      showControls: true,
      showFullscreenButton: true,
    ),
  );
  final _controllerEnglish = YoutubePlayerController(
    initialVideoId: 'ulFkotX2o0Q',
    params: YoutubePlayerParams(
      playlist: ['ulFkotX2o0Q', 'RHFMs3t8e00', '98Pz1IXCZ28'],
      showControls: true,
      showFullscreenButton: true,
    ),
  );*/

  Widget youtubePlayer(
    String initialVideoId,
    List<String> playlist,
  ) {
    return YoutubePlayerControllerProvider(
      controller: YoutubePlayerController(
        initialVideoId: initialVideoId,
        params: YoutubePlayerParams(
          playlist: playlist,
          showControls: true,
          showFullscreenButton: true,
        ),
      ),
      child: YoutubePlayerIFrame(
        aspectRatio: 16 / 9,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Player'.toUpperCase()),
          bottom: TabBar(tabs: [
            Tab(
                child: Text(
              'HINDI',
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            )),
            Tab(
                child: Text(
              'ENGLISH',
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            )),
          ]),
        ),
        body: TabBarView(children: <Widget>[
          /*YoutubePlayerControllerProvider(
            controller: _controllerHindi,
            child: YoutubePlayerIFrame(
              aspectRatio: 16 / 9,
            ),
          ),
          YoutubePlayerControllerProvider(
            controller: _controllerEnglish,
            child: YoutubePlayerIFrame(
              aspectRatio: 16 / 9,
            ),
          ),*/
          youtubePlayer(
            'gjgaIVzHjA0',
            ['gjgaIVzHjA0', 'q9jGrAkdnJU', 'kI9UIXLdxyk'],
          ),
          youtubePlayer(
            'ulFkotX2o0Q',
            ['ulFkotX2o0Q', 'RHFMs3t8e00', '98Pz1IXCZ28'],
          ),
        ]),
      ),
      length: 2,
    );
  }
}
