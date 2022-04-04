import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:developer';


class PlaylistData {
  final String name;
  final String link;

  PlaylistData({required this.name, required this.link});
  factory PlaylistData.fromJson(Map<String, dynamic> json) {
    return PlaylistData(
      name: json['name'],
      link: json['href'],
    );
  }
}

Future<PlaylistData> fetchPlaylists() async {
  final response = await http.get(
    Uri.parse('https://api.spotify.com/v1/me/playlists'),
    headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer BQDifu8-QPMuwsshrY9sHid5ugUWn16Ng-JBxjDvg8XCOpSdRtAAX0SmFrTijIzN_gBkaFuUG4meC-lFTBl-Fgu3bz3b_PgNKMzvdBAJbMSyVHdwP6KY1JT9jHeg1nSGLhvpNp7vyUPQMGQ9fxXE_Wc-TSss4KY',
    },
  );
  if (response.statusCode == 200) {
    log((jsonDecode(response.body)["items"][0]["name"]).toString());
    return PlaylistData.fromJson(jsonDecode(response.body)["items"][0]);
  } else {
    throw Exception('Failed to load album');
  }
}

class SubscriberSeries {
  final String year;
  final int subscribers;

  SubscriberSeries(
      {
        required this.year,
        required this.subscribers,
      }
      );
}

class SubscriberChart extends StatelessWidget {
  List<SubscriberSeries> data = [
    SubscriberSeries(
      year: "2008",
      subscribers: 10000000,
    ),
    SubscriberSeries(
      year: "2009",
      subscribers: 11000000,
    ),
    SubscriberSeries(
      year: "2010",
      subscribers: 12000000,
    ),
    SubscriberSeries(
      year: "2011",
      subscribers: 10000000,
    ),
    SubscriberSeries(
      year: "2012",
      subscribers: 8500000,
    ),
    SubscriberSeries(
      year: "2013",
      subscribers: 7700000,
    ),
    SubscriberSeries(
      year: "2014",
      subscribers: 7600000,
    ),
    SubscriberSeries(
      year: "2015",
      subscribers: 5500000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<charts.Series<SubscriberSeries, String>> series = [
      charts.Series(
          id: "Subscribers",
          data: data,
          domainFn: (SubscriberSeries series, _) => series.year,
          measureFn: (SubscriberSeries series, _) => series.subscribers,
      )
    ];

    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "World of Warcraft Subscribers by Year",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TaskTwo extends StatefulWidget {
  const TaskTwo({Key? key}) : super(key: key);

  @override
  _TaskDashboardState createState() => _TaskDashboardState();
}


class _TaskDashboardState extends State<TaskTwo> {
  late Future<PlaylistData> futurePlaylist;
  @override
  void initState() {
    super.initState();
    futurePlaylist= fetchPlaylists();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task-2',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.yellow.shade800,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
          child: ListView(
              children:[
                FutureBuilder(
                  future: futurePlaylist,
                  builder: (context, data) {
                    if (data.hasError) {
                      return Center(child: Text("${data.error}"));
                    } else if (data.hasData) {
                      log("here");
                      log(data.data..toString());
                      var items = data.data;
                      return ListView.builder(
                          itemCount: items == null ? 0 : items.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Container(
                                    //   width: 50,
                                    //   height: 50,
                                    //   child: Image(
                                    //     image:
                                    //     NetworkImage(items[index].imageURL.toString()),
                                    //     fit: BoxFit.fill,
                                    //   ),
                                    // ),
                                    Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8, right: 8),
                                                child: Text(
                                                  items[index].name.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 8, right: 8),
                                                child: Text(items[index].name.toString()),
                                              )
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                SubscriberChart(),
                SubscriberChart()
              ]
          )
      ),
    );
  }
}