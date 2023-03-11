import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:plantcare/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int motorSpeed = 100;
  String authtoken = "lkiX0mfnvHpsjrVsIHkXYQRbK8yftues";
  bool btnVal = false;
  int temperature = 0;
  int ligh = 0;
  int water = 0;
  bool isdeviceon = false;
  String lastWatering = "-";

  late Timer dataTimer;

  @override
  void initState() {
    super.initState();
    isdeviceActive();
    getv0Value();
    getv1Value();
    getv2Value();
    getv3Value();
    getv4Value();
    getv5Value();
    Timer.periodic(const Duration(seconds: 5), (result) {
      isdeviceActive();
      getv0Value();
      getv1Value();
      getv2Value();
      getv3Value();
      getv4Value();
      getv5Value();
    });
  }

  @override
  void dispose() {
    dataTimer.cancel();
    super.dispose();
  }

  void isdeviceActive() async {
    try {
      Response response = await get(Uri.parse(
              "https://sgp1.blynk.cloud/external/api/isHardwareConnected?token=$authtoken"))
          .timeout(const Duration(seconds: 60));
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        isdeviceon = jsonResponse;
      });
    } catch (e) {
      setState(() {
        isdeviceon = false;
      });
    }
  }

  void getv0Value() async {
    try {
      Response response = await get(Uri.parse(
              "https://sgp1.blynk.cloud/external/api/get?token=$authtoken&v0"))
          .timeout(const Duration(seconds: 60));
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        btnVal = (jsonResponse == 1) ? false : true;
      });
    } catch (e) {
      print(e);
    }
  }

  void getv1Value() async {
    try {
      Response response = await get(Uri.parse(
              "https://sgp1.blynk.cloud/external/api/get?token=$authtoken&v1"))
          .timeout(const Duration(seconds: 60));
      var jsonResponse = jsonDecode(response.body);
      water = jsonResponse;
      setState(() {
        water = (100 - ((water - 550) * 100) / (1024 - 550)).toInt();
        print(water);
      });
    } catch (e) {
      print(e);
    }
  }

  void getv2Value() async {
    try {
      Response response = await get(Uri.parse(
              "https://sgp1.blynk.cloud/external/api/get?token=$authtoken&v2"))
          .timeout(const Duration(seconds: 60));
      var jsonResponse = jsonDecode(response.body);
      var ms = ((jsonResponse / 255) * 100);
      setState(() {
        motorSpeed = ms.toInt();
      });
    } catch (e) {
      print(e);
    }
  }

  void getv3Value() async {
    try {
      Response response = await get(Uri.parse(
              "https://sgp1.blynk.cloud/external/api/get?token=$authtoken&v3"))
          .timeout(const Duration(seconds: 60));
      String jsonResponse = json.encode(response.body);
      setState(() {
        lastWatering = jsonResponse.replaceAll('"', "");
      });
    } catch (e) {
      print(e);
    }
  }

  void getv4Value() async {
    try {
      Response response = await get(Uri.parse(
              "https://sgp1.blynk.cloud/external/api/get?token=$authtoken&v4"))
          .timeout(const Duration(seconds: 60));
      var jsonResponse = jsonDecode(response.body);
      ligh = jsonResponse;
      setState(() {
        ligh = (((ligh - 0) * 100) / (1024 - 0)).toInt();
      });
    } catch (e) {
      print(e);
    }
  }

  void getv5Value() async {
    try {
      Response response = await get(Uri.parse(
              "https://sgp1.blynk.cloud/external/api/get?token=$authtoken&v5"))
          .timeout(const Duration(seconds: 60));
      var jsonResponse = jsonDecode(response.body);
      temperature = jsonResponse;
      setState(() {
        temperature = temperature.toInt();
      });
    } catch (e) {
      print(e);
    }
  }

  void setv0Value() async {
    setState(() {
      btnVal = !btnVal;
    });
    int val = (btnVal) ? 0 : 1;
    try {
      Response response = await get(Uri.parse(
              "https://sgp1.blynk.cloud/external/api/update?token=$authtoken&v0=$val"))
          .timeout(const Duration(seconds: 60));
      var jsonResponse = jsonDecode(response.body);
    } catch (e) {}
  }

  void setv2Value(val) async {
    print(val);
    try {
      Response response = await get(Uri.parse(
              "https://sgp1.blynk.cloud/external/api/update?token=$authtoken&v2=$val"))
          .timeout(const Duration(seconds: 60));
      var jsonResponse = jsonDecode(response.body);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ww = size.width / 100;
    double hh = size.height / 100;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: kPrimaryColor,
      //   title: Text("My Plants"),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              top: -ww * 0,
              right: -ww * 7,
              child: Container(
                width: ww * 10,
                height: ww * 20,
                padding: EdgeInsets.symmetric(horizontal: ww * 13),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: (isdeviceon) ? kPrimaryColor : Colors.red[700],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 4,
                      blurRadius: 30,
                      offset: Offset(0, 1),
                    )
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(ww * 2)),
                ),
              ),
            ),
            Positioned(
              top: -ww * 0,
              left: -ww * 10,
              child: Container(
                //width: ww * 80,
                height: ww * 20,
                padding: EdgeInsets.symmetric(horizontal: ww * 13),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 4,
                      blurRadius: 30,
                      offset: Offset(0, 1),
                    )
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(ww * 50)),
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: SvgPicture.asset(
                        "assets/img/plantpro.svg",
                        color: Colors.white,
                        width: 40,
                      ),
                    ),
                    SizedBox(width: 10),
                    const Text(
                      "My Plants",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: hh * 10),
                Image.asset(
                  "assets/img/plant3.png",
                  width: ww * 100,
                  height: hh * 50,
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: ww * 8, vertical: ww * 6),
                height: hh * 45,
                width: ww * 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 4,
                      blurRadius: 30,
                      offset: Offset(0, 1),
                    )
                  ],
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Time of last watering"),
                        Spacer(),
                        Text(lastWatering)
                      ],
                    ),
                    Divider(thickness: 1),
                    SizedBox(height: hh * 2),
                    Row(
                      children: [
                        SizedBox(width: ww * 10),
                        Column(
                          children: [
                            SvgPicture.asset(
                              "assets/img/water_drop.svg",
                              color: Colors.blue[500],
                              width: 50,
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: Text("$water%"),
                            )
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Icon(
                              Icons.thermostat_sharp,
                              size: 50,
                              color: Colors.red[700],
                            ),
                            SizedBox(height: 10),
                            Container(child: Text("$temperature°C")),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Icon(
                              Icons.light_mode,
                              color: Colors.amber[700],
                              size: 50,
                            ),
                            SizedBox(height: 10),
                            Container(child: Text("$ligh%")),
                          ],
                        ),
                        SizedBox(width: ww * 10),
                      ],
                    ),
                    SizedBox(height: hh * 1),
                    Divider(),
                    Row(
                      children: [Text("       Motor speed"), Spacer()],
                    ),
                    Slider(
                      thumbColor: kPrimaryColor,
                      activeColor: kPrimaryColor,
                      min: 0,
                      max: 100,
                      label: motorSpeed.toString(),
                      divisions: 100,
                      value: motorSpeed.toDouble(),
                      onChangeEnd: (val) {
                        setv2Value((((val * 255) / 100).toInt()));
                      },
                      onChanged: (val) {
                        setState(() => motorSpeed = val.toInt());
                      },
                    ),
                    SizedBox(height: hh * 2),
                    ElevatedButton(
                      onPressed: setv0Value,
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                      ),
                      child: Container(
                        height: hh * 7,
                        width: ww * 50,
                        alignment: Alignment.center,
                        child: Text(
                          (btnVal) ? "Turn on motor" : "Turn off motor",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
