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

Widget TagDropdown(addTag) {
  return Container (
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
  );
}
