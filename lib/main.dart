import 'package:BookDBFrontend/Inserts/AddQuote.dart';
import 'package:flutter/material.dart';
import 'Searches/TitleOrAuthorSearch.dart';
import 'Searches/TagSearch.dart';
import 'Searches/QuoteSearch.dart';

void main() {
  runApp(MaterialApp(
    title: 'BookDB',
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ButtonBar(
          children: <Widget> [
            RaisedButton(
              child: Text('Search by Title or Author'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TitleOrAuthorSearch()));
                // Navigate to second route when tapped.
              },
            ),
            RaisedButton(
              child: Text('Search by Tag'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TagSearch()));
                // Navigate to second route when tapped.
              },
            ),
            RaisedButton(
              child: Text('Search in Quote'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => QuoteSearch()));
                // Navigate to second route when tapped.
              },
            ),
            RaisedButton(
              child: Text('Add Quote'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddQuote()));
                // Navigate to second route when tapped.
              },
            )
          ],
          alignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}