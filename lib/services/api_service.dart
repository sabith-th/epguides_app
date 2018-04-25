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

class ApiService {
  final String epGuideBaseUrl = 'http://epguides.frecar.no/show/';

  Future<List<Episode>> getAllLatestEpisodes() async {
    var client = new http.Client();
    List<Episode> episodeList = [];
    List<http.Response> responseList = await Future.wait(seriesList
        .map((series) => client.get(epGuideBaseUrl + series + '/next')));
    for (var response in responseList) {
      Map map = json.decode(response.body);
      if (!map.containsKey("error")) {
        episodeList.add(new Episode.fromMap(map));
      }
    }
    client.close();
    return compute(sortEpisodesByAirDate, episodeList);
  }
}

List<Episode> sortEpisodesByAirDate(List<Episode> episodes) {
  episodes.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
  return episodes;
}
