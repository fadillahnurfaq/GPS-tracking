import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocatortest/homecontroller.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          ElevatedButton(
            onPressed: () async {
              await HomeController.checkPermision();
              await HomeController.getCurrentLocation();
              await HomeController.getContiniousLocation();
            },
            child: const Text("Mendapatkan GPS"),
          )
        ],
      ),
      body: ValueListenableBuilder<Position?>(
        valueListenable: HomeController.locationControllerCurrent,
        builder: (_, valueCurrent, __) {
          return ValueListenableBuilder<Position?>(
            valueListenable: HomeController.locationControllerStream,
            builder: (_, valueStream, __) {
              if (valueCurrent != null && valueStream != null) {
                return FutureBuilder(
                    future: HomeController.getContiniousLocation(),
                    builder: (context, snapStream) {
                      return FutureBuilder(
                          future: HomeController.getCurrentLocation(),
                          builder: (context, snapcurrent) {
                            double distance = Geolocator.distanceBetween(
                              valueCurrent.latitude,
                              valueCurrent.longitude,
                              valueStream.latitude,
                              valueStream.longitude,
                            );

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Center(
                                  child: Text(
                                    "GPS TRACKING",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                const Text(
                                  "Jarak",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  "${distance.toString().split(".").first} Meter",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            );
                          });
                    });
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Tidak ada data"),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
