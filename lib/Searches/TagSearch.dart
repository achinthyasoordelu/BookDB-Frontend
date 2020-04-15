import 'package:BookDBFrontend/Models/Tags.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:BookDBFrontend/globals.dart' as global;
import 'dart:async';
import 'dart:convert';

Future<Tags> fetchTags() async {
  final response = await http.get(global.baseURL + "query/getTags");
  if (response.statusCode == 200) {
    return Tags.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to get tags');
  }
}

class TagSearch extends StatefulWidget {
  @override
  _TagSearch createState() => new _TagSearch();
}

class _TagSearch extends State<TagSearch> {
  Set<String> selectedTags = new Set();
  String _selectedTags = "";
  Future<Tags> futureTags;

  @override
  void initState() {
    super.initState();
    futureTags = fetchTags();
  }

  @override
  Widget build(BuildContext context) {

    void resetTags() {
      selectedTags = new Set();
      setState(() => _selectedTags = "");
    }

    void addTag(String tag) {
        selectedTags.add(tag);
        setState(() => _selectedTags = selectedTags.toString());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Search by Tag"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Selected tags: $_selectedTags"),
            Container (
              width: 500,
              child: DropdownButtonHideUnderline(
                  child: new FutureBuilder<Tags>(
                    future: fetchTags(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return new Container();
                      } else if (snapshot.hasData) {
                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Select tag(s):",
                          ),
                          items: snapshot.data.tags.map((String tag) {
                            return new DropdownMenuItem<String>(
                              value: tag,
                              child: new Text(tag),
                            );
                          }).toList(),
                          onChanged: (chosenTag) {
                            addTag(chosenTag);
                          },
                        );
                      } else {
                        return LinearProgressIndicator();
                      }
                    },
                  )
              )
            ),
            RaisedButton(
              onPressed: () {
                resetTags();
              },
              child: Text('Reset Tags'),
            ),
            RaisedButton(
              onPressed: () {
                print(_selectedTags);
                //TODO query DB
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