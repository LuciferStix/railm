import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:railm/models/station.dart';

class TrainPage extends StatefulWidget {
    const TrainPage({super.key});

    @override
    State<StatefulWidget> createState() => _TrainPage();
}

class _TrainPage extends State<TrainPage> {
    List<Station> stations = [];

    Future<List<Station>> _fetchStations() async {
        final String url = "http://10.0.2.2:8080/stations";
        var response = await http.get(Uri.parse(url));

        final ids = List<String>.from(jsonDecode(response.body));
        final futures = ids.map((id) async {
            final resp = await http.get(Uri.parse("$url/$id"));
            final data = jsonDecode(resp.body);
            return Station.fromJson(data);
        });

        return await Future.wait(futures);
    }

    Future<void> _loadStations() async {
        final data = await _fetchStations();
        setState(() { stations = data; });
    }

    @override
    void initState() {
        super.initState();
        _loadStations();
    }

    @override
    Widget build(BuildContext context) {
        return Center(
            child: Padding(
                padding: .all(20),
                child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    mainAxisSize: .max,
                    spacing: 30,
                    children: [
                        SearchTrainNumber(),
                        SearchTrainsBetween(stations),
                    ]
                ),
            )
        );
    }
}

class SearchTrainNumber extends StatelessWidget {
    const SearchTrainNumber({super.key});

    Widget _heading() {
        return const Text(
            'Live Train',
            textScaler: .linear(3),
        );
    }

    Widget _trainNumberField() {
        return const TextField(
            decoration: InputDecoration(
                filled: true,
                hintText: 'Train Number',
                suffixIcon: IconButton(
                    onPressed: onClick,
                    color: Colors.blue,
                    icon: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                    borderSide: .none,
                    borderRadius: BorderRadius.all(.circular(10)),
                ),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Card(
            child: Container(
                padding: .all(10),
                width: .infinity,
                child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    mainAxisSize: .min,
                    children: [
                        _heading(),
                        const SizedBox(height: 20),
                        _trainNumberField(),
                    ],
                ),
            ),
        );
    }

    static void onClick() {}
}

class SearchTrainsBetween extends StatelessWidget {
    const SearchTrainsBetween(this.stations, {super.key});

    final List<Station> stations;

    Widget _heading() {
        return const Text(
            'Find Trains',
            textScaler: .linear(3),
        );
    }

    Widget _stationsDropDownMenu(String hintText) {
        return DropdownButtonFormField<String>(
            items: stations.map((s) {
                return DropdownMenuItem(
                    value: '${s.id}',
                    child: Text('${s.name} (${s.id.toUpperCase()})'),
                );
            }).toList(),
            onChanged: (x) {},
            borderRadius: .circular(10),
            decoration: InputDecoration(
                filled: true,
                hintText: hintText,
                border: OutlineInputBorder(
                    borderSide: .none,
                    borderRadius: BorderRadius.all(.circular(10)),
                ),
            ),
        );
    }

    Widget _searchButton() {
        return MaterialButton(
            minWidth: .infinity,
            height: 50,
            color: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: .all(.circular(10)),
            ),
            onPressed: (){},
            child: Row(
                mainAxisSize: .max,
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                spacing: 10,
                children: [
                    Text(
                        'Search',
                        style: .new(
                            fontSize: 20,
                            fontWeight: .w900,
                            color: Colors.white,
                        ),
                    ),
                    Icon(
                        Icons.search,
                        fontWeight: .w900,
                        color: Colors.white,
                    ),
                ],
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Card(
            child: Container(
                padding: .all(10),
                width: .infinity,
                child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    mainAxisSize: .min,
                    children: [
                        _heading(),
                        const SizedBox(height: 20),
                        _stationsDropDownMenu('From'),
                        const SizedBox(height: 10),
                        _stationsDropDownMenu('To'),
                        const SizedBox(height: 20),
                        _searchButton(),
                    ],
                ),
            ),
        );
    }
}
