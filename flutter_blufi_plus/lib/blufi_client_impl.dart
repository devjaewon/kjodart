part of flutter_blufi_plus;

class BlufiClientImpl extends BlufiClient {
  BlufiClientImpl({
    required super.device,
  });
  
  @override
  Future<void> close() async {}
  
  @override
  Future<void> configure(BlufiConfigureParams params) async {}
  
  @override
  Future<void> connect() async {}
  
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
}
