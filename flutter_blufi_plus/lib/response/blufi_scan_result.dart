part of flutter_blufi_plus;

class BlufiScanResult {
  static const int typeWifi = 0x01;

  int type = 0;

  String ssid = '';

  int rssi = 0;

  @override
  String toString() {
    return 'ssid: $ssid, rssi: $rssi';
  }
}
