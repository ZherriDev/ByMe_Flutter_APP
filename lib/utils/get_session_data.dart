import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:device_info/device_info.dart';
import 'package:country_provider/country_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> getDeviceInfo() async {
  Map<String, dynamic> deviceData = {
    'deviceModel': 'Unknown',
    'osName': 'Unknown',
    'ipAddress': 'Unknown',
  };

  try {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData['deviceModel'] = androidInfo.model;
      deviceData['osName'] = 'Android ${androidInfo.version.release}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData['deviceModel'] = iosInfo.model;
      deviceData['osName'] = 'IOS ${iosInfo.systemVersion}';
    }

    deviceData['ipAddress'] = await getPublicIpAddress();
  } catch (e) {
    print('Erro ao obter informações: $e');
  }

  return deviceData;
}

Future<String> getPublicIpAddress() async {
  try {
    final response =
        await http.get(Uri.parse('https://api.ipify.org?format=json'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['ip'];
    } else {
      throw Exception('Falha ao obter endereço IP público');
    }
  } catch (e) {
    print('Erro ao obter endereço IP público: $e');
    return 'Unknown';
  }
}
