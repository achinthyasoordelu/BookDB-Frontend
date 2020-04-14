import 'package:flutter/material.dart';

class TagSearch extends StatefulWidget {
  @override
  _TagSearch createState() => new _TagSearch();
}

class _TagSearch extends State<TagSearch> {
  Set<String> selectedTags = new Set();
  String _selectedTags = "";
  var tags = <String> ["Finance", "Business", "Technology"]; //TODO fetch with DB query

  @override
  Widget build(BuildContext context) {

    void updateSelectedTagText() {
      setState(() => _selectedTags = selectedTags.toString());
    }

    void resetTags() {
      selectedTags = new Set();
      setState(() => _selectedTags = "");
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
              child: TagDropDown(
                    (String tag) {
                      selectedTags.add(tag);
                      updateSelectedTagText();
                      },
                tags,
              ),
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

class TagDropDown extends StatefulWidget {
  final Function(String) addTag;
  final List<String> tags;
  TagDropDown(this.addTag, this.tags);

  @override
  _TagDropDownState createState() => _TagDropDownState();
}

class _TagDropDownState extends State<TagDropDown> {

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Select tag(s):",
      ),
      items: widget.tags.map((String tag) {
        return new DropdownMenuItem<String>(
          value: tag,
          child: new Text(tag),
        );
      }).toList(),
      onChanged: (chosenTag) {
        widget.addTag(chosenTag);
      },
    );
  }
}