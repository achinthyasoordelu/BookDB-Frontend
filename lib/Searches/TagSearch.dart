import 'package:flutter/material.dart';

class TagSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search by Tag"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Select tags:",
                    //TODO convert to drop down based on DB query
                  ),
                )
            ),
            RaisedButton(
              onPressed: () {
                //TODO query DB
                // Navigate back to first route when tapped.
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
      )
    );
  }
}