import 'package:BookDBFrontend/Models/Quote.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<Quote> fetchQuote(url) async { //TODO convert this to a list of quotes
  final response = await http.get(url);
  if (response.statusCode == 200) {
    Quote quote = Quote.fromJson(json.decode(response.body));
    return quote;
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
      for (var i = 0; i < 10; i++) {
        quoteList.add(await fetchQuote(widget.queryURL));
        //TODO add some iterator to note to get next page of results
      }
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
        title: Text("Quotes")
      ),
      body: ListView.builder(
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return _buildProgressIndicator();
          } else {
            return Card(child: Column(
              children: <Widget>[
                Text("Title: " + items[index].title),
                Text("Author: " + items[index].author),
                Text("Quote: "+ items[index].quote),
                Text("Tags: "+ items[index].tags.toString()),
              ],
            )
            );
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
}

/*class _QuoteList extends State<QuoteList> {

  final InfiniteScrollController _infiniteController = InfiniteScrollController(
    initialScrollOffset: 0.0,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Example'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: () {
                _infiniteController.animateTo(_infiniteController.offset + 2000.0,
                    duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () {
                _infiniteController.animateTo(_infiniteController.offset - 2000.0,
                    duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
              },
            ),
          ],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'First'),
              Tab(text: 'Second'),
              Tab(text: 'Third'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            build_scroll(),
            build_scroll(),
            build_scroll(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build_scroll() {
    
    return Scaffold(
        appBar: AppBar(
          title: Text("Results"),
        ),
        body: Center(
          child: InfiniteListView.separated(
              controller: _infiniteController,
              itemBuilder: (BuildContext context, int index) {
                return FutureBuilder<Quote>(
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
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 2.0), anchor: 0.5,
          )
        )
    );
  }
}*/
