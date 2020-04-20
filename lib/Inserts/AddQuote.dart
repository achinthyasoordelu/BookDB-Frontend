import 'dart:convert';

import 'package:BookDBFrontend/Models/Quote.dart';
import 'package:BookDBFrontend/Models/Tags.dart';
import 'package:BookDBFrontend/Models/UI/TagDropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:BookDBFrontend/globals.dart' as global;

Future<http.Response> postQuote(Quote quote) {
  return http.post(
    global.baseURL + "insertQuote",
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(quote),
  );
}

class AddQuote extends StatefulWidget {
  @override
  _AddQuote createState() => new _AddQuote();
}

class _AddQuote extends State<AddQuote> {
  Set<String> selectedTags = new Set();
  String _selectedTags = "";
  Future<Tags> futureTags;
  final TextEditingController _quoteController = new TextEditingController();
  final _addQuoteFormKey = GlobalKey<FormState>();
  Quote quote = new Quote("","","",[]);

  void resetTags() {
    selectedTags = new Set();
    setState(() => _selectedTags = "");
  }

  void addTag(String tag) {
    selectedTags.add(tag);
    setState(() => _selectedTags = selectedTags.toString()
        .replaceAll(' ', '')
        .replaceAll('{', '')
        .replaceAll('}', ''));
  }

  void loadSelectedTagsIntoQuote() {
    quote.tags = _selectedTags.split(",");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Quote"),
      ),
      body: Center(
        child: Form(
          key: _addQuoteFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: 500,
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    onSaved: (String value) {
                      quote.title = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a title';
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Title"
                    )
                  )
                ),
                Container(
                    width: 500,
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                        onSaved: (String value) {
                          quote.author = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an author';
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Author"
                        )
                    )
                ),
                Container(
                    width: 1000,
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField( //TODO add formatting capabilities
                        onSaved: (String value) {
                          quote.quote = value;
                          _quoteController.clear();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a quote';
                          }
                        },
                        controller: _quoteController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Quote"
                        )
                    )
                ),
                Container(
                    child: Text("Selected tags: $_selectedTags"),
                ),
                TagDropdown(addTag),
                RaisedButton(
                  onPressed: () {
                    resetTags();
                  },
                  child: Text('Reset Tags'),
                ),
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    print(_selectedTags);
                    if (_addQuoteFormKey.currentState.validate() && _selectedTags != "") {
                      print("Valid input");
                      _addQuoteFormKey.currentState.save(); //Load title, author, and quote into quote model
                      loadSelectedTagsIntoQuote();
                      resetTags(); //Clear tags after submit for next submit
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return new FutureBuilder(
                                future: postQuote(quote),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError || snapshot.hasData && snapshot.data.statusCode != 200) {
                                    return AlertDialog(
                                        title: new Text("Error"),
                                        content: new Text("Insert failed"),
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
                                  else if (snapshot.hasData) {
                                    return AlertDialog(
                                        title: new Text("Inserted successfully"),
                                        actions: <Widget> [
                                          new FlatButton(
                                              child: new Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              }
                                          )
                                        ]);
                                  } else {
                                    return Container();
                                  }
                                }
                            );
                          }
                      );
                    } else if (_selectedTags == "") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("Error"),
                            content: new Text("No tags selected"),
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
                    }
                  },
                  child: Text('Submit'),
                ),
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Home'),
                ),
              ]
            )
          )
        )
      )
    );
  }
}