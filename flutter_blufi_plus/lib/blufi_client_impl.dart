part of flutter_blufi_plus;

class BlufiClientImpl extends BlufiClient {
  BlufiClientImpl({
    required super.device,
  });

  static const int defaultPackageLength = 20;

  static const int packageHeaderLength = 4;

  static const int minPackageLength = 20;

  late BluetoothService _service;

  late BluetoothCharacteristic _writeChar;

  late BluetoothCharacteristic _notifyChar;

  late StreamSubscription<List<int>> _notifySub;

  bool printDebug = BlufiConfig.debug;

  @override
  Future<void> close() async {
    await _notifySub.cancel();
    await device.disconnect();
  }
  
  @override
  Future<void> configure(BlufiConfigureParams params) async {}
  
  @override
  Future<void> connect() async {
    await device.connect();
    await _initMembersAndSubscriptions();
  }
  
  @override
  Future<void> negotiateSecurity() async {}
  
  @override
  Future<void> postCustomData(Uint8List data) async {}
  
  @override
  void printDebugLog(bool enable) {}
  
  @override
  Future<void> requestCloseConnection() async {}
  
  @override
  Future<void> requestDeviceStatus() async {}
  
  @override
  Future<void> requestDeviceVersion() async {}
  
  @override
  Future<void> requestDeviceWifiScan() async {}
  
  @override
  void setBlufiCallback(BlufiCallback callback) {}
  
  @override
  void setGattWriteTimeout(int timeout) {}
  
  @override
  void setPostPackageLengthLimit(int lengthLimit) {}

  Future<bool> _initMembersAndSubscriptions() async {
    final services = await device.discoverServices();
    final si = services.indexWhere((service) => service.uuid == BlufiParameter.uuidService);
    if (si < 0) {
      return false;
    }
    _service = services[si];

    final wci = _service.characteristics.indexWhere((characteristic) {
      return characteristic.uuid == BlufiParameter.uuidWriteCharacteristic;
    });
    if (wci < 0) {
      return false;
    }
    _writeChar = _service.characteristics[wci];

    final nci = _service.characteristics.indexWhere((characteristic) {
      return characteristic.uuid == BlufiParameter.uuidNotificationCharacteristic;
    });
    if (nci < 0) {
      return false;
    }
    _notifyChar = _service.characteristics[nci];
    await _notifyChar.setNotifyValue(true);
    _notifySub = _notifyChar.onValueReceived.listen(_onNotificationReceived);

    return true;
  }

  void _onNotificationReceived(List<int> response) {

  }
}
