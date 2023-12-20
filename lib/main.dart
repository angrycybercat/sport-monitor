import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:file_system/file_system.dart';

void main() {
  runApp(MyApp());
}

//4
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothPage(),
    );
  }
}

//1
class ActivityTrackerPage extends StatefulWidget {
  @override
  _ActivityTrackerPageState createState() => _ActivityTrackerPageState();
}

class _ActivityTrackerPageState extends State<ActivityTrackerPage> {
  String selectedActivity = 'Vélo';
  final List<String> activities = ['Vélo', 'Course à pied', 'Marche'];
  bool isTracking = false;
  String wifiStatus = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Tracker'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedActivity,
              onChanged: (String? newValue) {
                setState(() {
                  selectedActivity = newValue!;
                });
              },
              items: activities.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: toggleTracking,
              child: Text(isTracking ? 'Stop Activity' : 'Start Activity'),
            ),
            Text('Wi-Fi Status: $wifiStatus'),
          ],
        ),
      ),
    );
  }

  void toggleTracking() {
    setState(() {
      isTracking = !isTracking;
      // Add logic for Bluetooth and data handling
    });
  }
}

//5
class ConnectivityPage extends StatefulWidget {
  @override
  _ConnectivityPageState createState() => _ConnectivityPageState();
}

class _ConnectivityPageState extends State<ConnectivityPage> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    var connectivityResult = ConnectivityResult.none;
    try {
      connectivityResult = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }
    return _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      switch (result) {
        case ConnectivityResult.wifi:
          _connectionStatus = 'Connected to Wi-Fi';
          break;
        case ConnectivityResult.mobile:
          _connectionStatus = 'Connected to Mobile Network';
          break;
        case ConnectivityResult.none:
          _connectionStatus = 'No Internet Connection';
          break;
        default:
          _connectionStatus = 'Failed to get connectivity.';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connectivity Status'),
      ),
      body: Center(
        child: Text(_connectionStatus),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _connectivity.onConnectivityChanged
        .listen(_updateConnectionStatus)
        .cancel();
  }
}

//6
class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  bool isConnecting = true;
  bool get isConnected => connection?.isConnected ?? false;

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.requestEnable();
    // Add more setup code here if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Connect'),
      ),
      body: Center(
        child: Text(isConnected ? 'Connected' : 'Not Connected'),
      ),
    );
  }

  // Add more methods here for handling Bluetooth
}
