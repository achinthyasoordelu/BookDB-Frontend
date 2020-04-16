import 'dart:convert';

class Quote {
  String author;
  String title;
  String quote;
  List<String> tags;

  Quote(this.author, this.title, this.quote, this.tags);

  /*factory Quote.fromJson(Map<String, dynamic> json) {
    print("In Quote");
    return Quote(
        author: json['Author'],
        title: json['Title'],
        quote: json['quote'],
        tags: json['tags'].cast<String>()
    );
  }*/

  factory Quote.fromJson(dynamic json) {
    var decodedJson = jsonDecode(json[0]);
    return Quote(
        decodedJson['Author'] as String,
        decodedJson['Title'] as String,
        decodedJson['quote'] as String,
        decodedJson['tags'].cast<String>() as List<String>);
  }
}