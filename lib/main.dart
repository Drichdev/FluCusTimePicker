import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            // Configuration des thèmmes de l'application des couleurs des éléments
            seedColor: Colors.deepPurple,
            onPrimary: Colors.white,
            surfaceTint: Colors.white,
            onPrimaryContainer: Colors.black,
            onSecondaryContainer: Colors.white),
        useMaterial3: true,
      ),
      home: const Center(
        child: HourCust(),
      ),
    );
  }
}

class HourCust extends StatefulWidget {
  const HourCust({super.key});

  @override
  State<HourCust> createState() => _HourCustState();
}

class _HourCustState extends State<HourCust> {
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  Future<void> _selectTime({required bool isStartTime}) async {
    final TimeOfDay? newTime = await showTimePicker(
      helpText: "Choisir l'horaire",
      cancelText: "Annuler",
      confirmText: "OK",
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (newTime != null) {
      setState(() {
        if (isStartTime) {
          if (newTime.hour < _endTime.hour ||
              (newTime.hour == _endTime.hour &&
                  newTime.minute < _endTime.minute)) {
            _startTime = newTime;
          } else {
            _showErrorDialog(
                'L\'heure de début doit être avant l\'heure de fin.');
          }
        } else {
          if (newTime.hour > _startTime.hour ||
              (newTime.hour == _startTime.hour &&
                  newTime.minute > _startTime.minute)) {
            _endTime = newTime;
          } else {
            _showErrorDialog(
                'L\'heure de fin doit être après l\'heure de début.');
          }
        }
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sélection d\'heure invalide'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélection des heures de travail'),
      ),
      body: Center(
        child: Container(
          width: 380,
          height: 130,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    'Debut',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 24), // text color
                      side: const BorderSide(
                          color: Colors.grey,
                          width: 1), // border color and width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _selectTime(isStartTime: true),
                    child: Text(_startTime.format(context)),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              const Text(
                '>',
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  const Text(
                    'Fin',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 24), // text color
                      side: const BorderSide(
                          color: Colors.grey,
                          width: 1), // border color and width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _selectTime(isStartTime: false),
                    child: Text(_endTime.format(context)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
