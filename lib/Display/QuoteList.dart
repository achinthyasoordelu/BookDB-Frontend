import 'package:BookDBFrontend/globals.dart' as global;
import 'package:BookDBFrontend/Inserts/EditQuote.dart';
import 'package:BookDBFrontend/Models/Quote.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<List<Quote>> fetchQuote(url, isContinue) async {
  if (isContinue) {
    url = global.baseURL + "query/continueQuery/";
  }
  final response = await http.get(url);
  if (response.statusCode == 200) {
    var quotesJson = json.decode(response.body)['quotes'] as List;
    return quotesJson.map((quote) => Quote.fromJson(quote)).toList();
  } else {
    throw Exception('Failed to get quote from $url');
  }
}

class QuoteList extends StatefulWidget {
  final String queryURL;
  final String headerDisplay;
  const QuoteList({this.queryURL, this.headerDisplay});

  @override
  _QuoteList createState() => new _QuoteList();
}

class _QuoteList extends State<QuoteList> {
  static const int mdash = 0x2014;
  List<Quote> items = new List();
  bool isPerformingRequest = false;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _getMoreData();

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      List<Quote> quoteList = new List();
      quoteList.addAll(await fetchQuote(widget.queryURL, items.length > 0));
      setState(() {
        items.addAll(quoteList);
        isPerformingRequest = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Quotes for " + widget.headerDisplay)
      ),
      body: ListView.builder(
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return _buildProgressIndicator();
          } else {
            return _getContextDependentCard(items[index]);
          }
        },
        controller: _scrollController,
      )
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
            opacity: isPerformingRequest ? 1 : 0,
            child: new CircularProgressIndicator())
      )
    );
  }
  
  Widget _getContextDependentCard(Quote quote) {
    if (widget.queryURL.contains("tagSearch")) {
      return Card(
          child: Column(
            children: <Widget>[
              Text(
                quote.title + String.fromCharCode(mdash) + quote.author,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 15,
                  fontFamily: 'NotoSerif',
                ),
              ),
              SizedBox(height: 10),
              Text(
                quote.quote,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NotoSerif',
                ),
              ),
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                            EditQuote(quote: quote)));
                      },
                      child: Image.asset('assets/icons8-edit-24.png')
                  )
              )
            ],
          )
      );
    } else {
      return Card(
          child: Column(
            children: <Widget>[
              Text(
                quote.title + String.fromCharCode(mdash) + quote.author,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 15,
                  fontFamily: 'NotoSerif',
                ),
              ),
              SizedBox(height: 10),
              Text(
                quote.quote,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NotoSerif',
                ),
              ),
              SizedBox(height: 10),
              Text(
                  "Tags: "+ quote.tags.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'NotoSerif',
                  )
              ),
              Align(
                alignment: Alignment.bottomRight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>
                            EditQuote(quote: quote)));
                      },
                      child: Image.asset('assets/icons8-edit-24.png')
                  )
              )
            ],
          )
      );
    }
  }
}