class Quote {
  final String author;
  final String title;
  final String quote;
  final List<String> tags;

  Quote({this.author, this.title, this.quote, this.tags});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        author: json['Author'],
        title: json['Title'],
        quote: json['quote'],
        tags: json['tags'].cast<String>()
    );
  }
}