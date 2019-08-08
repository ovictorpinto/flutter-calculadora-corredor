import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecordWidget extends StatelessWidget {
  final Future<List<Record>> post = fetchPost();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Record>>(
          future: post,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text(snapshot.data[index].dist),
                      title: Text(snapshot.data[index].athlete),
                      subtitle: Text(snapshot.data[index].date),
                      trailing: Text(snapshot.data[index].tempo),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          }),
    );
  }
}

Future<List<Record>> fetchPost() async {
  final response = await http.get(
      'https://raw.githubusercontent.com/ovictorpinto/flutter-calculadora-corredor/master/support/records.json');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    var list = json.decode(response.body)["records"] as List;
    return list.map((i) => Record.fromJson(i)).toList();
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Record {
  final String dist;
  final String tempo;
  final String athlete;
  final String date;

  Record({this.dist, this.tempo, this.athlete, this.date});

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      dist: json['dist'],
      tempo: json['tempo'],
      athlete: json['athlete'],
      date: json['date'],
    );
  }
}
