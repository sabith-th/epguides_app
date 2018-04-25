import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:epguides_app/models/episode.dart';

final List<String> seriesList = [
  'agentsofshield',
  'arrow',
  'bigbangtheory',
  'blacklist',
  'brooklynninenine',
  'flash_2014',
  'gooddoctor',
  'lastweektonightwithjohnoliver',
  'mick',
  'modernfamily',
  'siliconvalley',
  'supernatural',
  'youngsheldon'
];

void main() async {
  var apiService = new ApiService();
  List<Episode> episodes = await apiService.getAllLatestEpisodes();
  episodes.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
  for (var episode in episodes) {
    episode.printEpisode();
  }
}

class ApiService {
  final String epGuideBaseUrl = 'http://epguides.frecar.no/show/';

  void getNextEpisode() async {
    http.Response response =
        await http.get(epGuideBaseUrl + seriesList[0] + '/next');
    var output = json.decode(response.body);
    print(output);
    Episode nextEpisode = new Episode.fromMap(output);
    nextEpisode.printEpisode();
  }

  Future<List<Episode>> getAllLatestEpisodes() async {
    var client = new http.Client();
    List<Episode> episodeList = [];
    for (var series in seriesList) {
      await client.get(epGuideBaseUrl + series + '/next').then((response) {
        Map map = json.decode(response.body);
        if (!map.containsKey("error")) {
          episodeList.add(new Episode.fromMap(map));
        }
      });
    }
    client.close();
    return compute(sortEpisodesByAirDate, episodeList);
  }

}

List<Episode> sortEpisodesByAirDate(List<Episode> episodes) {
  episodes.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
  return episodes;
}
