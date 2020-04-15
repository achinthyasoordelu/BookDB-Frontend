import 'package:BookDBFrontend/Models/Quote.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<Quote> fetchQuote(url) async {
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return Quote.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to get quote from $url');
  }
}

class QuoteList extends StatefulWidget {
  final String queryURL;
  const QuoteList({this.queryURL});

  @override
  _QuoteList createState() => new _QuoteList();
}

class _QuoteList extends State<QuoteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Results"),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              new FutureBuilder<Quote>(
                future: fetchQuote(widget.queryURL),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return new Container();
                  } else if (snapshot.hasData) {
                    return Card(
                      child: Column(
                        children: <Widget>[
                          Text("Title: " + snapshot.data.title),
                          Text("Author: " + snapshot.data.author),
                          Text("Quote: " + snapshot.data.quote),
                          Text("Tags: " + snapshot.data.tags.toString()),
                        ],
                      )
                    );
                  } else {
                    return LinearProgressIndicator();
                  }
                },
              )
            ]
          )
        )
    );
  }
}
