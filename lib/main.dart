import 'package:epguides_app/models/episode.dart';
import 'package:epguides_app/services/api_service.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Episode Guide App',
      home: new EpisodeGuideHome(),
    );
  }
}

class EpisodeGuideHome extends StatefulWidget {
  @override
  EpisodeHomeState createState() => new EpisodeHomeState();
}

class EpisodeHomeState extends State<EpisodeGuideHome> {
  Widget _buildEpisodeListView(List<Episode> episodes) {
    return new ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: episodes.length,
      itemBuilder: (context, i) {
        if (i == 0) {
          return _buildUpcomingEpisodeCard(episodes[i]);
        } else {
          return _buildEpisodeCard(episodes[i]);
        }
      },
    );
  }

  Widget _buildUpcomingEpisodeCard(Episode episode) {
    return new Card(
      child: new Column(
        children: <Widget>[
          new Text(
            'Upcoming',
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          new Divider(),
          _buildEpisodeListTile(episode)
        ],
      ),
    );
  }

  Widget _buildEpisodeCard(Episode episode) {
    return new Card(
      child: _buildEpisodeListTile(episode),
    );
  }

  Widget _buildEpisodeListTile(Episode episode) {
    return new ListTile(
      leading: new CircleAvatar(
        child: new Text(episode.showTitle[0]),
      ),
      title: new Text(episode.showTitle),
      subtitle: new RichText(
          text: new TextSpan(children: [
        new TextSpan(
            text: 'Episode: ${episode.title}\n',
            style: new TextStyle(color: Colors.black)),
        new TextSpan(
            text: 'Air Date: ${episode.releaseDate}',
            style: new TextStyle(color: Colors.black))
      ])),
      isThreeLine: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Episode Guide'),
      ),
      body: new FutureBuilder(
          future: new ApiService().getAllLatestEpisodes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildEpisodeListView(snapshot.data);
            } else if (snapshot.hasError) {
              return new Text('${snapshot.error}');
            }
            return new Center(
              child: new CircularProgressIndicator(),
            );
          }),
    );
  }
}
