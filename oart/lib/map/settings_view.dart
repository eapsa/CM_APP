import 'package:flutter/material.dart';
import 'package:oart/map/shared_preferences.dart';

const List<String> languages = <String>[
  "en",
  "pt",
  "fr",
  "es",
  "de",
];

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool test = false;
  String dropdownValue = languages.first;
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    getStoredValue();
  }

  getStoredValue() async {
    test = await SharedPreferencesHelper.getTTS();
    dropdownValue = await SharedPreferencesHelper.getLanguage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: _settingsList(),
    );
  }

  Widget _settingsList() {
    return Padding(
        padding: EdgeInsets.only(
            left: deviceWidth(context) * 0.1,
            right: deviceWidth(context) * 0.1),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SwitchListTile(
              title: const Text("Text to speech"),
              value: test,
              onChanged: (bool value) async {
                await SharedPreferencesHelper.setTTS(value);
                test = value;
                setState(() {});
              },
            ),
            DropdownButton(
              isExpanded: true,
              value: dropdownValue,
              onChanged: (String? value) async {
                await SharedPreferencesHelper.setLanguage(value!);
                setState(() {
                  dropdownValue = value;
                });
              },
              items: languages.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  alignment: Alignment.center,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            )
          ],
        ));
  }
}
