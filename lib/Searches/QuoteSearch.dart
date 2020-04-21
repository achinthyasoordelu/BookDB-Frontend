import 'package:flutter/material.dart';
import 'package:BookDBFrontend/globals.dart' as global;
import 'package:BookDBFrontend/Display/QuoteList.dart';

class QuoteSearch extends StatefulWidget {
  @override
  _QuoteSearch createState() => new _QuoteSearch();
}

class _QuoteSearch extends State<QuoteSearch> {

  final quoteSearchController = TextEditingController();

  @override
  void dispose() {
    quoteSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search in Quote Text"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                width: 500,
                child: TextFormField(
                  controller: quoteSearchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter part of quote:",
                  ),
                )
            ),
            RaisedButton(
              onPressed: () {
                if (quoteSearchController.text.replaceAll(" ", "").length == 0) {
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
                      QuoteList(
                          queryURL: global.baseURL + "query/quoteSearch/" +
                              quoteSearchController.text,
                          headerDisplay: quoteSearchController.text)));
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