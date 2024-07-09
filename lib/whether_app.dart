import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:whether_app/additonal_info_item.dart';
import 'package:whether_app/secret.dart';
import 'hourly_whether.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  TextEditingController cityNameController = TextEditingController();
  double currenttemp = 0;
  String currentsky = '';
  double currenthumidity = 0;
  double currentPressure = 0;
  double windspeed = 0.0;
  String cityname = 'Pune';

  Future<Map<String, dynamic>> getcurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$openWhetherAPIKey',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw data['message'];
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Whether App',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getcurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('An Unexpected Error Occurred'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No Data Available'));
          }

          final data = snapshot.data!;
          final currentWeather = data['list'][0];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: cityNameController,
                    decoration: InputDecoration(
                      hintText: '   Enter City Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(25),
                          right: Radius.circular(25),
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        cityname = value;
                      });
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Text(
                                  '${currentWeather['main']['temp']} °K',
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Icon(
                                  currentWeather['weather'][0]['main'] ==
                                              'Rain' ||
                                          currentWeather['weather'][0]
                                                  ['main'] ==
                                              'Clouds'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 68,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  currentWeather['weather'][0]['main'],
                                  style: TextStyle(fontSize: 25),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Weather Forecast',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < data['list'].length - 1; i++)
                          if (DateFormat('yyyy-MM-dd').format(DateTime.now()) ==
                              data['list'][i + 1]['dt_txt']
                                  .toString()
                                  .split(" ")[0])
                            cardwhethercast(
                              time: DateFormat('h:mm a').format(
                                DateTime.parse(data['list'][i + 1]['dt_txt']),
                              ),
                              temperature: data['list'][i + 1]['main']['temp']
                                  .toString(),
                              icon: data['list'][i + 1]['weather'][0]['main'] ==
                                          'Rain' ||
                                      data['list'][i + 1]['weather'][0]
                                              ['main'] ==
                                          'Drizzle'
                                  ? Icons.water_drop
                                  : data['list'][i + 1]['weather'][0]['main'] ==
                                          'Clouds'
                                      ? Icons.cloud
                                      : data['list'][i + 1]['weather'][0]
                                                  ['main'] ==
                                              'Clear'
                                          ? Icons.sunny
                                          : Icons.help,
                            ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      additioninfoitem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentWeather['main']['humidity'].toDouble(),
                      ),
                      additioninfoitem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentWeather['wind']['speed'].toDouble(),
                      ),
                      additioninfoitem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentWeather['main']['pressure'].toDouble(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
