import 'package:BookDBFrontend/Models/Tags.dart';
import 'package:BookDBFrontend/Models/UI/TagDropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddQuote extends StatefulWidget {
  @override
  _AddQuote createState() => new _AddQuote();
}

class _AddQuote extends State<AddQuote> {
  Set<String> selectedTags = new Set();
  String _selectedTags = "";
  Future<Tags> futureTags;
  final _addQuoteFormKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Quote"),
      ),
      body: Center(
        child: Form( //TODO form validation
          key: _addQuoteFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: 500,
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
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
                    print(_selectedTags);
                    if (_addQuoteFormKey.currentState.validate() && _selectedTags != "") {
                      print("Valid input");
                      //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                      //TODO backend post
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