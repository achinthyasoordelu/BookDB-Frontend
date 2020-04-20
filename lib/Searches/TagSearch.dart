import 'package:BookDBFrontend/Display/QuoteList.dart';
import 'package:BookDBFrontend/Models/Tags.dart';
import 'package:BookDBFrontend/Models/UI/TagDropdown.dart';
import 'package:flutter/material.dart';
import 'package:BookDBFrontend/globals.dart' as global;
import 'dart:async';


class TagSearch extends StatefulWidget {
  @override
  _TagSearch createState() => new _TagSearch();
}

class _TagSearch extends State<TagSearch> {
  Set<String> selectedTags = new Set();
  String _selectedTags = "";
  Future<Tags> futureTags;

  @override
  Widget build(BuildContext context) {

    void resetTags() {
      selectedTags = new Set();
      setState(() => _selectedTags = "");
    }

    void addTag(String tag) {
        selectedTags.add(tag);
        setState(() => _selectedTags = selectedTags.toString()
            .replaceAll(', ', ',')
            .replaceAll('{', '')
            .replaceAll('}', ''));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Search by Tag"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Selected tags: $_selectedTags"),
            TagDropdown(addTag),
            RaisedButton(
              onPressed: () {
                resetTags();
              },
              child: Text('Reset Tags'),
            ),
            RaisedButton(
              onPressed: () {
                print(_selectedTags);
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    QuoteList(queryURL: global.baseURL + "query/tagSearch/" + _selectedTags,
                              headerDisplay: _selectedTags)));
              },
              child: Text('Submit'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
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

