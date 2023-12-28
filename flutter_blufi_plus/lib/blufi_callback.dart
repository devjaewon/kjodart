part of flutter_blufi_plus;

abstract class BlufiCallback {
  static const statusSuccess = 0;
  
  static const codeInvalidNotification = -1000;

  static const codeCatchException = -1001;

  static const codeWriteDataFailed = -1002;

  static const codeInvalidData = -1003;

  static const codeNegPostFailed = -2000;

  static const codeNegErrDevKey = -2001;

  static const codeNegErrSecurity = -2002;

  static const codeNegErrSetSecurity = -2003;

  static const codeConfInvalidOpMode = -3000;

  static const codeConfErrSetOpMode = -3001;

  static const codeConfErrPostSta = -3002;

  static const codeConfErrPostSoftAp = -3003;

  static const codeGattWriteTimeout = -4000;

  static const codeWifiScanFail = 11;

  void onGattPrepared(
    BlufiClient client,
    FlutterBluePlus bluePlus,
    BluetoothService service,
    BluetoothCharacteristic writeChar,
    BluetoothCharacteristic notifyChar,
  ) {}

  bool onGattNotification(
    BlufiClient client,
    int pkgType,
    int subType,
    Uint8List data,
  ) {
    return false;
  }

  void onError(
    BlufiClient client,
    int errCode,
  ) {}

  void onNegotiateSecurityResult(
    BlufiClient client,
    int status,
  ) {}

  // @deprecated
  void onConfigureResult(
    BlufiClient client,
    int status,
  ) {}

  void onPostConfigureParams(
    BlufiClient client,
    int status,
  ) {
    onConfigureResult(client, status);
  }

  void onDeviceVersionResponse(
    BlufiClient client,
    int status,
    BlufiVersionResponse response,
  ) {}

  void onDeviceStatusResponse(
    BlufiClient client,
    int status,
    BlufiStatusResponse? response,
  ) {}

  void onDeviceScanResult(
    BlufiClient client,
    int status,
    List<BlufiScanResult> results,
  ) {}

  void onPostCustomDataResult(
    BlufiClient client,
    int status,
    Uint8List data,
  ) {}

  void onReceiveCustomData(
    BlufiClient client,
    int status,
    Uint8List data,
  ) {}
}
