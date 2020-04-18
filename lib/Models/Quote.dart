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
    var decodedJson = jsonDecode(json[0]);
    return Quote(
        decodedJson['Author'] as String,
        decodedJson['Title'] as String,
        decodedJson['quote'] as String,
        decodedJson['tags'].cast<String>() as List<String>);
  }
}