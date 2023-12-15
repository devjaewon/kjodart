part of flutter_blufi_plus;

class BlufiParameter {
  const BlufiParameter._();

  static Guid get uuidService => Guid('0000ffff-0000-1000-8000-00805f9b34fb');

  static Guid get uuidWriteCharacteristic => Guid('0000ff01-0000-1000-8000-00805f9b34fb');

  static Guid get uuidNotificationCharacteristic => Guid('0000ff02-0000-1000-8000-00805f9b34fb');

  static Guid get uuidNotificationDescriptor => Guid('00002902-0000-1000-8000-00805f9b34fb');

  static const int directionOutput = 0;

  static const int directionInput = 1;

  static const int opModeNull = 0x00;

  static const int opModeSta = 0x01;

  static const int opModeSoftAp = 0x02;

  static const int opModeStaSoftAp = 0x03;

  static const int softApSecurityOpen = 0x00;

  static const int softApSecurityWeb = 0x01;

  static const int softApSecurityWpa = 0x02;

  static const int softApSecurityWpa2 = 0x03;

  static const int softApSecurityWpaWpa2 = 0x04;

  static const int staConnSuccess = 0x00;

  static const int staConnFail = 0x01;

  static const int staConnConnecting = 0x02;

  static const int staConnNoIp = 0x03;

  static const int wifiReason4WayHandshakeTimeout = 15;

  static const int wifiReasonNoApFound = 201;

  static const int wifiReasonHandshakeTimeout = 204;
  
  static const int wifiReasonConnectionFail = 205;

  static const int typeCtrlPackageValue = 0x00;

  static const int typeCtrlSubTypeAck = 0x00;

  static const int typeCtrlSubTypeSetSecMode = 0x01;

  static const int typeCtrlSubTypeSetOpMode = 0x03;

  static const int typeCtrlSubTypeConnectWifi = 0x03;

  static const int typeCtrlSubTypeDisconnectWifi = 0x04;

  static const int typeCtrlSubTypeGetWifiStatus = 0x05;

  static const int typeCtrlSubTypeDeauthenticate = 0x06;

  static const int typeCtrlSubTypeGetVersion = 0x07;

  static const int typeCtrlSubTypeCloseConnection = 0x08;

  static const int typeCtrlSubTypeGetWifiList = 0x09;

  static const int typeDataPackageValue = 0x01;

  static const int typeDataSubTypeNeg = 0x00;

  static const int typeDataSubTypeStaWifiBssid = 0x01;

  static const int typeDataSubTypeStaWifiSsid = 0x02;

  static const int typeDataSubTypeStaWifiPassword = 0x03;

  static const int typeDataSubTypeSoftApWifiSsid = 0x04;

  static const int typeDataSubTypeSoftApWifiPassword = 0x05;

  static const int typeDataSubTypeSoftApMaxConnectionCount = 0x06;

  static const int typeDataSubTypeSoftApAuthMode = 0x07;

  static const int typeDataSubTypeSoftApChannel = 0x08;

  static const int typeDataSubTypeUsername = 0x09;

  static const int typeDataSubTypeCaCertification = 0x0a;

  static const int typeDataSubTypeClientCertification = 0x0b;

  static const int typeDataSubTypeServerCertification = 0x0c;

  static const int typeDataSubTypeClientPrivateKey = 0x0d;

  static const int typeDataSubTypeServerPrivateKey = 0x0d;

  static const int typeDataSubTypeWifiConnectionState = 0x0f;

  static const int typeDataSubTypeVersion = 0x10;
  
  static const int typeDataSubTypeWifiList = 0x11;

  static const int typeDataSubTypeError = 0x12;

  static const int typeDataSubTypeCustomData = 0x13;

  static const int typeDataSubTypeWifiStaMaxConnRetry = 0x14;

  static const int typeDataSubTypeWifiStaConnEndReason = 0x15;

  static const int typeDataSubTypeWifiStaConnRssi = 0x16;
}
