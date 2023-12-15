part of flutter_blufi_plus;

class BlufiStatusResponse {
  int opMode = -1;

  int softApSecurity = -1;

  int softApConnCount = -1;

  int softApMaxConnCount = -1;

  int softApChannel = -1;

  String? softApPassword;

  String? softApSsid;

  int staConnectionStatus = -1;

  String? staBssid;

  String? staSsid;

  String? staPassword;

  int connectionRssiLimit = -60;

  int connectionMaxRetry = -1;

  int connectionEndReason = -1;

  int connectionRssi = -128;

  bool get isStaConnectWifi {
    return staConnectionStatus == 0;
  }

  bool isReasonValid(int reason) {
    return (reason >= 0 && reason <= 24) || (reason == 53) || (reason >= 200 && reason <= 207);
  }

  bool isRssiValid(int rssi) {
    return rssi > -128 && rssi <= 127;
  }

  String get endInfo {
    final msg = StringBuffer();
    final reasonCode = isReasonValid(connectionEndReason) ? connectionEndReason : 'N/A';
    final rssi = isRssiValid(connectionRssi) ? connectionRssi : 'N/A';

    msg.writeln(
      'Reason code: $reasonCode, '
      'Rssi: $rssi',
    );

    if (connectionEndReason == BlufiParameter.wifiReasonNoApFound) {
      msg.writeln('NO AP FOUND');
    } else if (connectionEndReason == BlufiParameter.wifiReasonConnectionFail) {
      msg.writeln('AP IN BLACKLIST, PLEASE RETRY');
    } else if (isRssiValid(connectionRssi)) {
      if (connectionRssi < connectionRssiLimit) {
        msg.writeln('RSSI IS TOO LOW');
      } else if (connectionEndReason == BlufiParameter.wifiReason4WayHandshakeTimeout || connectionEndReason == BlufiParameter.wifiReasonHandshakeTimeout) {
        msg.writeln('WRONG PASSWORD');
      }
    }

    return msg.toString();
  }

  String get connectingInfo {
    final msg = StringBuffer();

    msg.write('Max Retry is ');
    if (connectionMaxRetry == -1) {
      msg.writeln('N/A');
    } else {
      msg.writeln('$connectionMaxRetry');
    }

    return msg.toString();
  }

  String get validInfo {
    final info = StringBuffer();
    info.write('OpMode: ');
    
    switch(opMode) {
      case BlufiParameter.opModeNull:
        info.write('NULL');
        break;
      case BlufiParameter.opModeSta:
        info.write('Station');
        break;
      case BlufiParameter.opModeSoftAp:
        info.write('SoftAP');
        break;
      case BlufiParameter.opModeStaSoftAp:
        info.write('Station/SoftAP');
        break;
    }

    info.writeln('');

    switch (opMode) {
      case BlufiParameter.opModeSta:
      case BlufiParameter.opModeStaSoftAp:
        if (isStaConnectWifi) {
          info.writeln('Station connect Wi-Fi now, got IP');
        } else if (staConnectionStatus == BlufiParameter.staConnNoIp) {
          info.writeln('Station connect Wi-Fi now, no IP found');
        } else if (staConnectionStatus == BlufiParameter.staConnFail) {
          info.writeln('Station disconnect Wi-Fi now');
          info.write(endInfo);
        } else {
          info.writeln('Station is connecting WiFi now');
          info.write(connectingInfo);
        }
        if (staBssid != null) {
          info.writeln('Station connect Wi-Fi bssid: $staBssid');
        }
        if (staSsid != null) {
          info.writeln('Station connect Wi-Fi sssid: $staSsid');
        }
        if (staPassword != null) {
          info.writeln('Station connect Wi-Fi password: $staPassword');
        }
        break;
    }

    switch (opMode) {
      case BlufiParameter.opModeSoftAp:
      case BlufiParameter.opModeStaSoftAp:
        switch (softApSecurity) {
          case BlufiParameter.softApSecurityOpen:
            info.writeln('SoftAP security: OPEN');
            break;
          case BlufiParameter.softApSecurityWeb:
            info.writeln('SoftAP security: WEB');
            break;
          case BlufiParameter.softApSecurityWpa:
            info.writeln('SoftAP security: WPA');
            break;
          case BlufiParameter.softApSecurityWpa2:
            info.writeln('SoftAP security: WPA2');
            break;
          case BlufiParameter.softApSecurityWpaWpa2:
            info.writeln('SoftAP security: WPA/WPA2');
            break;
        }
        if (softApSsid != null) {
          info.writeln('SoftAP ssid: $softApSsid');
        }
        if (softApPassword != null) {
          info.writeln('SoftAP password: $softApPassword');
        }
        if (softApChannel >= 0) {
          info.writeln('SoftAP channel: $softApChannel');
        }
        if (softApMaxConnCount > 0) {
          info.writeln('SoftAP max connection: $softApMaxConnCount');
        }
        if (softApConnCount >= 0) {
          info.writeln('SoftAP current connection: $softApConnCount');
        }
        break;
    }

    return info.toString();
  }
}
