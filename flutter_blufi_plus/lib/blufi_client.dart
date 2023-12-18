part of flutter_blufi_plus;

abstract class BlufiClient {
  BlufiClient({
    required this.device,
  });

  factory BlufiClient.create({required BluetoothDevice device}) {
    return BlufiClientImpl(device: device);
  }

  static const version = BlufiConfig.versionName;

  final BluetoothDevice device;

  void printDebugLog(bool enable);

  void setBlufiCallback(BlufiCallback callback);

  void setPostPackageLengthLimit(int lengthLimit);

  void setGattWriteTimeout(int timeout);

  Future<void> connect();

  Future<void> close();

  Future<void> negotiateSecurity();

  Future<void> requestCloseConnection();

  Future<void> requestDeviceVersion();

  Future<void> requestDeviceStatus();

  Future<void> requestDeviceWifiScan();

  Future<void> configure(BlufiConfigureParams params);

  Future<void> postCustomData(Uint8List data);
}
