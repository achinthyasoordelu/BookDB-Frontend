import 'dart:convert';

import 'package:BookDBFrontend/globals.dart' as global;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:BookDBFrontend/Models/Quote.dart';
import 'package:BookDBFrontend/Models/UI/TagDropdown.dart';

Future<http.Response> postEditedQuote(Quote quote) {
  return http.post(
    global.baseURL + "updateQuote",
    headers: <String, String> {
      'Content-Type' : 'application/json; charset=UTF-8',
    },
    body: jsonEncode(quote),
  );
}

class EditQuote extends StatefulWidget {
  final Quote quote;
  const EditQuote({this.quote});

  @override
  _EditQuote createState() => new _EditQuote();
}

class _EditQuote extends State<EditQuote> {
  Set<String> selectedTags;
  String _selectedTags = "";
  final _addQuoteFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    getInitiallySelectedTags();
    super.initState();
  }

  void getInitiallySelectedTags() {
    selectedTags = widget.quote.tags;
    for (String tag in selectedTags) {
      addTag(tag);
    }
  }

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

  void loadSelectedTagsIntoQuote() {
    widget.quote.tags = _selectedTags.split(",").toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Quote"),
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
                                  initialValue: widget.quote.title,
                                  onSaved: (String value) {
                                    widget.quote.title = value;
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
                                  initialValue: widget.quote.author,
                                  onSaved: (String value) {
                                    widget.quote.author = value;
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
                                  initialValue: widget.quote.quote,
                                  onSaved: (String value) {
                                    widget.quote.quote = value;
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a quote';
                                    }
                                  },
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
                              if (_addQuoteFormKey.currentState.validate() && _selectedTags != "") {
                                _addQuoteFormKey.currentState.save(); //Load title, author, and quote into quote model
                                loadSelectedTagsIntoQuote();
                                resetTags(); //Clear tags after submit for next submit
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return new FutureBuilder(
                                          future: postEditedQuote(widget.quote),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError || snapshot.hasData && snapshot.data.statusCode != 200) {
                                              return AlertDialog(
                                                  title: new Text("Error"),
                                                  content: new Text("Edit failed"),
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
                                                  title: new Text("Edited successfully"),
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