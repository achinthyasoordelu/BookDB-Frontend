import 'package:flutter/material.dart';
import 'package:BookDBFrontend/globals.dart' as global;
import 'package:BookDBFrontend/Display/QuoteList.dart';

class TitleOrAuthorSearch extends StatefulWidget {
  @override
  _TitleOrAuthorSearch createState() => new _TitleOrAuthorSearch();
}

class _TitleOrAuthorSearch extends State<TitleOrAuthorSearch> {

  final titleOrAuthorSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search by Title or Author"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: 500,
                child: TextFormField(
                  controller: titleOrAuthorSearchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter part of title or author:",
                  ),
                )
            ),
            RaisedButton(
              onPressed: () {
                if (titleOrAuthorSearchController.text.replaceAll(" ", "").length == 0) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: new Text("Error"),
                            content: new Text("Add a search term"),
                            actions: <Widget> [
                              new FlatButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }
                              )
                            ]
                        );
                      }
                  );
                } else {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                      QuoteList(queryURL: global.baseURL +
                          "query/titleOrAuthorSearch/" +
                          titleOrAuthorSearchController.text,
                          headerDisplay: titleOrAuthorSearchController.text)));
                }
              },
              child: Text('Submit'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate back to first route when tapped.
              },
              child: Text('Home'),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}