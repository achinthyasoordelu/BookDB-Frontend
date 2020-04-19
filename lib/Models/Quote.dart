import 'dart:convert';

class Quote {
  String author;
  String title;
  String quote;
  List<String> tags;

  Quote(this.author, this.title, this.quote, this.tags);

  Map<String, dynamic> toJson() =>
      {
        'title' : title,
        'author' : author,
        'quote' : quote,
        'tags' : tags.join(",")
      };

  factory Quote.fromJson(dynamic json) {
    return Quote(
        json['Author'] as String,
        json['Title'] as String,
        json['Quote'] as String,
        json['Tags'].split(","));
  }
}