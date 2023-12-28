part of flutter_blufi_plus;

class BlufiConfigureParams {
  BlufiConfigureParams();

  static const int serialVersionUid = 1;

  int opMode = 0;

  String staBssid = '';

  BlufiBytes staSsidBytes = BlufiBytes();

  String staPassword = '';

  int softApSecurity = 0;

  String softApSsid = '';

  String softApPassword = '';

  int softApChannel = 0;

  int softApMaxConnection = 0;

  BlufiBytes get staPasswordBytes {
    return BlufiBytes(bytes: Uint8List.fromList(utf8.encode(staPassword)));
  }

  @override
  String toString() {
    final str = 'op mode = $opMode, '
      'sta bssid = $staBssid'
      'sta ssid = $staSsidBytes' 
      'sta password = $staPassword'
      'softap security = $softApSecurity'
      'softap ssid = $softApSsid'
      'softap password = $softApPassword'
      'softap channel = $softApChannel'
      'softap max connection = $softApMaxConnection';

    return str;
  }
}
