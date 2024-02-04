import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool light1 = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Setting", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Restaurant Notification", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("Enable Notification")
                        ],
                      ),
                      Switch(value: light1, onChanged: (value) => setState(() {
                        light1 = value;
                      }))
                    ],
                  ),
                )
              ],
            ),
          )
        )
    );
  }
}