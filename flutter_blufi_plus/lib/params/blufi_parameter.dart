part of flutter_blufi_plus;

class _BlufiParameterTypeCtrl {
  final int typeCtrlPackageValue = 0x00;

  final int typeCtrlSubTypeAck = 0x00;

  final int typeCtrlSubTypeSetSecMode = 0x01;

  final int typeCtrlSubTypeSetOpMode = 0x03;

  final int typeCtrlSubTypeConnectWifi = 0x03;

  final int typeCtrlSubTypeDisconnectWifi = 0x04;

  final int typeCtrlSubTypeGetWifiStatus = 0x05;

  final int typeCtrlSubTypeDeauthenticate = 0x06;

  final int typeCtrlSubTypeGetVersion = 0x07;

  final int typeCtrlSubTypeCloseConnection = 0x08;

  final int typeCtrlSubTypeGetWifiList = 0x09;
}

class _BlufiParameterTypeData {
  final int typeDataPackageValue = 0x01;

  final int typeDataSubTypeNeg = 0x00;

  final int typeDataSubTypeStaWifiBssid = 0x01;

  final int typeDataSubTypeStaWifiSsid = 0x02;

  final int typeDataSubTypeStaWifiPassword = 0x03;

  final int typeDataSubTypeSoftApWifiSsid = 0x04;

  final int typeDataSubTypeSoftApWifiPassword = 0x05;

  final int typeDataSubTypeSoftApMaxConnectionCount = 0x06;

  final int typeDataSubTypeSoftApAuthMode = 0x07;

  final int typeDataSubTypeSoftApChannel = 0x08;

  final int typeDataSubTypeUsername = 0x09;

  final int typeDataSubTypeCaCertification = 0x0a;

  final int typeDataSubTypeClientCertification = 0x0b;

  final int typeDataSubTypeServerCertification = 0x0c;

  final int typeDataSubTypeClientPrivateKey = 0x0d;

  final int typeDataSubTypeServerPrivateKey = 0x0d;

  final int typeDataSubTypeWifiConnectionState = 0x0f;

  final int typeDataSubTypeVersion = 0x10;
  
  final int typeDataSubTypeWifiList = 0x11;

  final int typeDataSubTypeError = 0x12;

  final int typeDataSubTypeCustomData = 0x13;

  final int typeDataSubTypeWifiStaMaxConnRetry = 0x14;

  final int typeDataSubTypeWifiStaConnEndReason = 0x15;

  final int typeDataSubTypeWifiStaConnRssi = 0x16;
}

class _BlufiParameterType {
  final ctrl = _BlufiParameterTypeCtrl();
  final data = _BlufiParameterTypeData();
}

class BlufiParameter {
  final Guid uuidService = Guid('0000ffff-0000-1000-8000-00805f9b34fb');

  final Guid uuidWriteCharacteristic = Guid('0000ff01-0000-1000-8000-00805f9b34fb');

  final Guid uuidNotificationCharacteristic = Guid('0000ff02-0000-1000-8000-00805f9b34fb');

  final Guid uuidNotificationDescriptor = Guid('00002902-0000-1000-8000-00805f9b34fb');

  final int directionOutput = 0;

  final int directionInput = 1;

  final int opModeNull = 0x00;

  final int opModeSta = 0x01;

  final int opModeSoftAp = 0x02;

  final int opModeStaSoftAp = 0x03;

  final int softApSecurityOpen = 0x00;

  final int softApSecurityWeb = 0x01;

  final int softApSecurityWpa = 0x02;

  final int softApSecurityWpa2 = 0x03;

  final int softApSecurityWpaWpa2 = 0x04;

  final int staConnSuccess = 0x00;

  final int staConnFail = 0x01;

  final int staConnConnecting = 0x02;

  final int staConnNoIp = 0x03;

  final int wifiReason4WayHandshakeTimeout = 15;

  final int wifiReasonNoApFound = 201;

  final int wifiReasonHandshakeTimeout = 204;
  
  final int wifiReasonConnectionFail = 205;

  final type = _BlufiParameterType();
}

final blufiParameter = BlufiParameter();
