// SPDX-License-Identifier: GPL-2.0
// Author: xunicatt
// Project: railm (railm) 
// Copyright (c) 2026 xunicatt <contact.aniket.biswas@gmail.com>

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:railm/models/station.dart';
import 'package:railm/models/status.dart';
import 'package:railm/models/train.dart';

class TrainLiveStatusPage extends StatefulWidget {
    final Train train;
    final List<Station> stations;

    const TrainLiveStatusPage({
        super.key,
        required this.train,
        required this.stations,
    });

    @override
    State<StatefulWidget> createState() => _TrainLiveStatusPage();
}

class _TrainLiveStatusPage extends State<TrainLiveStatusPage> {
    bool liveMode = false;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: SafeArea(
                child: Container(
                    alignment: .topCenter,
                    padding: .all(10),
                    child: Column(
                        mainAxisAlignment: .start,
                        crossAxisAlignment: .center,
                        children: [
                            TrainLiveStatusHeading(
                                trainNumber: widget.train.number,
                                trainName: widget.train.name,
                                value: liveMode,
                                onChanged: (x) {
                                    setState(() { liveMode = x; });
                                }
                            ),
                            Expanded(
                                child: TrainStopsList(
                                    trainNumber: widget.train.number,
                                    stops: widget.train.stops,
                                    stations: widget.stations,
                                    isLiveMode: liveMode,
                                ),
                            ),
                        ], 
                    ),
                ),
            ),
        );
    }
}

class TrainLiveStatusHeading extends StatelessWidget {
    final String trainNumber;
    final String trainName;
    final ValueChanged<bool> onChanged;
    final bool value;

    const TrainLiveStatusHeading({
        super.key,
        required this.trainName,
        required this.trainNumber,
        required this.onChanged,
        required this.value,
    });

    @override
    Widget build(BuildContext context) {
        return Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
                Padding(
                    padding: .only(left: 10),
                    child: Text(
                        trainName,
                        style: .new(
                            fontSize: 18,
                            fontWeight: .w900,
                        )
                    ),
                ),
                Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                        Padding(
                            padding: .only(left: 10),
                            child: Container(
                                padding: .symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: .all(.circular(4)),
                                ),
                                child: Text(
                                    trainNumber,
                                    style: .new(
                                        color: Colors.white,
                                    ),
                                ),
                            ),
                        ),
                        Row(
                            children: [
                                Padding(
                                    padding: .only(left: 10),
                                    child: Text(
                                        'Live Mode',
                                        style: .new(
                                            color: Colors.grey,
                                        ),
                                    ),
                                ),
                                Switch(
                                    activeThumbColor: Colors.blue,
                                    value: value,
                                    onChanged: onChanged,
                                ),
                            ],
                        ),
                    ],
                ) 
            ],
        );
    }
}

class TrainStopsList extends StatefulWidget {
    final String trainNumber;
    final List<TrainStop> stops;
    final List<Station> stations;
    final bool isLiveMode;

    const TrainStopsList({
        super.key,
        required this.trainNumber,
        required this.stops,
        required this.stations,
        required this.isLiveMode,
    });

    @override
    State<StatefulWidget> createState() => _TrainStopsList();
}

class _TrainStopsList extends State<TrainStopsList> {
    Status? status;
    Timer? timer;

    @override
    void initState() {
        super.initState();

        timer = Timer.periodic(
            Duration(seconds: 2),
            (_) async {
                if (widget.isLiveMode) {
                    return;
                }

                final data = await Status.fetchStatus(widget.trainNumber);

                if (!mounted) {
                    return;
                }

                setState(() {
                    status = data;
                });
            }
        );
    }

    @override
    void dispose() {
        super.dispose();
        timer?.cancel();
    }

    VoidCallback? getOnTap(String stationId) {
        if (!widget.isLiveMode) {
            return null;
        }

        return () {
            // TODO: improve error handling
            // for update failure
            setState(() {
                status = Status(
                    state: TrainStatus.running,
                    number: widget.trainNumber,
                    station: stationId,
                );
            });

            Status.updateStatus(
                widget.trainNumber,
                stationId,
            );
        };
    }

    @override
    Widget build(BuildContext context) {
        return Column(
            children: [
                const TrainStopsListHeading(),
                Expanded(
                    child: Card(
                        clipBehavior: .hardEdge,
                        child: ListView.separated(
                            itemCount: widget.stops.length,
                            itemBuilder: (context, index) {
                                final stop = widget.stops[index];
                                return TrainStopCard(
                                    stop: stop,
                                    stations: widget.stations,
                                    here: status != null ?
                                            status?.station == stop.station :
                                            false,
                                    onTap: getOnTap(stop.station),
                                );
                            },
                            separatorBuilder: (context, index) {
                                return Divider(
                                    height: 0,
                                    thickness: 1,
                                );
                            },
                        ),
                    ),
                ),
            ],
        );
    }
}

class TrainStopsListHeading extends StatelessWidget {
    const TrainStopsListHeading({super.key});

    @override
    Widget build(BuildContext context) {
        return Container(
            width: .infinity,
            padding: .all(10),
            child: Row(
                children: [
                    Expanded(
                        flex: 1,
                        child: Icon(
                            Icons.location_on,
                            color: Colors.blue,
                        ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Text(
                            'Arrival',
                            style: .new(
                                fontWeight: .w800,
                            ),
                        ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Text(
                            'Station',
                            style: .new(
                                fontWeight: .w800,
                            ),
                        ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Text(
                            'Departure',
                            style: .new(
                                fontWeight: .w800,
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}

class TrainStopCard extends StatelessWidget {
    final TrainStop stop;
    final List<Station> stations;
    final bool here;
    final VoidCallback? onTap;
    late Station station;

    TrainStopCard({
        super.key,
        required this.stop,
        required this.stations,
        required this.here,
        this.onTap,
    }) {
        station = stations.firstWhere(
            (s) => s.id == stop.station
        );
    }

    @override
    Widget build(BuildContext context) {
        Widget arrival = stop.arrival == "--:--" ?
                            Icon(
                                Icons.subdirectory_arrow_right,
                                color: Colors.blue,
                            ) : Text(stop.arrival);

        Widget departure = stop.departure == "--:--" ?
                            Icon(
                                Icons.arrow_forward,
                                color: Colors.blue,
                            ) : Text(stop.departure);
        return InkWell(
            onTap: onTap,
            child: Container(
                padding: .all(10),
                child: Row(
                    children: [
                        Expanded(
                            flex: 1,
                            child: Icon(
                                here ? Icons.train : null,
                                color: Colors.green,
                            ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                                alignment: .centerStart,
                                child: arrival, 
                            ),
                        ),
                        Expanded(
                            flex: 4,
                            child: Container(
                                alignment: .centerStart,
                                child: Text(station.name),
                            ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                                alignment: .centerEnd,
                                child: departure,
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
