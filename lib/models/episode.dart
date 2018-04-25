class Episode {
  String title, showTitle, showId, releaseDate;
  int season, number;

  Episode.fromMap(Map<String, dynamic> map) {
    this.title = map["episode"]["title"];
    this.showId = map["episode"]["show"]["imdb_id"];
    this.showTitle = map["episode"]["show"]["title"];
    this.releaseDate = map["episode"]["release_date"];
    this.season = map["episode"]["season"];
    this.number = map["episode"]["number"];
  }

  void printEpisode() {
    print(
        'Ep Title: $title, Show: $showTitle, Show Id: $showId, Date: $releaseDate, S$season E$number');
  }
}
