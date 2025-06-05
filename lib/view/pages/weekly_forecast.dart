import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyForecast extends StatefulWidget {
  Map<String, dynamic> currentValue = {};
  final String city;
  final List<dynamic> pastWeek;
  final List<dynamic> next7Days;

  WeeklyForecast({
    super.key,
    required this.city,
    required this.currentValue,
    required this.next7Days,
    required this.pastWeek,
  });

  @override
  State<WeeklyForecast> createState() => _WeeklyForecastState();
}

String formattedTime(String dataString) {
  DateTime time = DateTime.parse(dataString);
  return DateFormat('d MMMM, EEEE').format(time);
}

class _WeeklyForecastState extends State<WeeklyForecast> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          widget.city,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 40,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '${widget.currentValue['temp_c']} ℃',
                          style: TextStyle(
                              fontSize: 50,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${widget.currentValue['condition']['text']}",
                          style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        Image.network(
                          'https:${widget.currentValue['condition']?['icon'] ?? ''}',
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Next 7 days forecast",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ...widget.next7Days.map((day) {
                    final data = day['date'] ?? '';
                    final condition = day['day']?['condition']?['text'] ?? '';
                    final icon = day['day']?['condition']?['icon'] ?? '';
                    final maxTemp = day['day']?['maxtemp_c'] ?? '';
                    final minTemp = day['day']?['mintemp_c'] ?? '';
                    return ListTile(
                      leading: Image.network(
                        'https:$icon',
                        width: 40,
                      ),
                      title: Text(
                        formattedTime(data),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      subtitle: Text(
                        '$condition  $minTemp ℃ - $maxTemp ℃',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    );
                  })
                ],
              ),
            ),
          )),
    );
  }
}
