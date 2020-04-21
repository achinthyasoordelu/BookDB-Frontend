import 'dart:convert';

class Quote {
  int id = 0;
  String author;
  String title;
  String quote;
  Set<String> tags;

  Quote(this.id, this.author, this.title, this.quote, this.tags);

  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'title' : title,
        'author' : author,
        'quote' : quote,
        'tags' : tags.join(",")
      };

  factory Quote.fromJson(dynamic json) {
    return Quote(
        json['QuoteID'] as int,
        json['Author'] as String,
        json['Title'] as String,
        json['Quote'] as String,
        json['Tags'].split(",").toSet());
  }
}