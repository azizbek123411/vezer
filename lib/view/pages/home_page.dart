import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vezer/provider/theme_provider.dart';
import 'package:vezer/service/api_service.dart';
import 'package:intl/intl.dart';
import 'package:vezer/view/pages/weekly_forecast.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final weatherService = WeatherApiService();
  String city = 'Tashkent';
  String country = '';
  Map<String, dynamic> currentValue = {};
  List<dynamic> hourly = [];
  List<dynamic> pastWeek = [];
  List<dynamic> next7Days = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    setState(() {
      isLoading = true;
    });

    try {
      final forecast = await weatherService.getHourlyForecast(city);
      final past = await weatherService.getSevenDayWeather(city);
      setState(() {
        currentValue = forecast['current'] ?? {};
        hourly = forecast['forecast']?['forecastday']?[0]['hour'] ?? [];

        next7Days = forecast['forecast']?['forecastday'] ?? [];
        pastWeek = past;
        country = forecast['location']?['country'] ?? '';
        isLoading = false;
      });
    } catch (e, st) {
      setState(() {
        currentValue = {};
        hourly = [];
        pastWeek = [];
        next7Days = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('City not found.Please enter a valid city name'),
        ),
      );
    }
  }

  String formattedTime(String timeString) {
    DateTime time = DateTime.parse(timeString);
    return DateFormat.j().format(time);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final notifier = ref.read(themeNotifierProvider.notifier);
    final isDark = themeMode == ThemeMode.dark;

    String iconPath = currentValue['condition']?['icon'] ?? "";
    String imageurl = iconPath.isNotEmpty ? "https:$iconPath" : "";
    Widget imageWidget = imageurl.isNotEmpty
        ? Image.network(
            imageurl,
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          )
        : SizedBox();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          SizedBox(
            width: 25,
          ),
          SizedBox(
            height: 50,
            width: 300,
            child: TextField(
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
              ),
              onSubmitted: (value) {
                if (value.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a city name'),
                    ),
                  );
                  return;
                }
                city = value.trim();
                fetchWeather();
              },
              decoration: InputDecoration(
                hintText: 'Search city',
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.surface,
                ),
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: notifier.toggleTheme,
            icon: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).colorScheme.surface,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else ...[
              if (currentValue.isNotEmpty)
                Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Text(
                    "$city${country.isNotEmpty ? ', $country' : ''}",
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 28,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${currentValue['temp_c']} ℃',
                    style: TextStyle(
                        fontSize: 50,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${currentValue['condition']['text']}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  imageWidget,
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.maxFinite,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary,
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/humidity.png',
                                width: 30,
                              ),
                              Text(
                                '${currentValue['humidity']}%',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Text(
                                'Humidity',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Image.asset(
                                'assets/wind.png',
                                width: 30,
                                color: Colors.white,
                              ),
                              Text(
                                '${currentValue['wind_kph']}kph',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Text(
                                'Wind',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Image.asset(
                                'assets/temp.png',
                                width: 30,
                              ),
                              Text(
                                "${hourly.isNotEmpty ? hourly.map((h) => h['temp_c']).reduce((a, b) => a > b ? a : b) : "N/A"}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Text(
                                'Max Temp',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 250,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Today Forecast',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WeeklyForecast(
                                          city: city,
                                          currentValue: currentValue,
                                          next7Days: next7Days,
                                          pastWeek: pastWeek),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Weekly Forecast',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 155,
                          child: ListView.builder(
                              itemCount: hourly.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final hour = hourly[index];
                                final now = DateTime.now();
                                final hourTime = DateTime.parse(hour['time']);
                                final isCurrentHour = now.hour == hourTime.hour &&
                                    now.day == hourTime.day;
                                return Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Container(
                                    height: 70,
                                    width: 80,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isCurrentHour
                                          ? Colors.orangeAccent
                                          : Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          isCurrentHour
                                              ? 'Now'
                                              : formattedTime(
                                                  hour['time'],
                                                ),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Image.network(
                                          'https:${hour['condition']?['icon']}',
                                          width: 80,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "${hour['temp_c']} ℃",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  )
                ]),
            ]
          ],
        ),
      ),
    );
  }
}
