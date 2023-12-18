part of flutter_blufi_plus;

class BlufiClientImpl extends BlufiClient {
  BlufiClientImpl({
    required super.device,
  });

  static const int defaultPackageLength = 20;

  static const int packageHeaderLength = 4;

  static const int minPackageLength = 20;

  final List<int> _ack = [];

  late BluetoothService _service;

  late BluetoothCharacteristic _writeChar;

  late BluetoothCharacteristic _notifyChar;

  late StreamSubscription<List<int>> _notifySub;

  BlufiCallback? _blufiUserCallback;

  BlufiNotifyData? _notifyData;

  int _writeTimeout = -1;

  int _packageLengthLimit = -1;

  int _blufiMtu = -1;

  bool _printDebug = BlufiConfig.debug;

  bool _encrypted = false;

  bool _checksum = false;

  bool _requireAck = false;

  int _sendSequence = -1;

  int _readSequence = -1;

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
  void printDebugLog(bool enable) {
    _printDebug = enable;
  }
  
  @override
  Future<void> requestCloseConnection() async {}
  
  @override
  Future<void> requestDeviceStatus() async {}
  
  @override
  Future<void> requestDeviceVersion() async {}
  
  @override
  Future<void> requestDeviceWifiScan() {
    return _requestDeviceWifiScan();
  }
  
  @override
  void setBlufiCallback(BlufiCallback callback) {
    _blufiUserCallback = callback;
  }
  
  @override
  void setGattWriteTimeout(int timeout) {
    _writeTimeout = timeout;
  }
  
  @override
  void setPostPackageLengthLimit(int lengthLimit) {
    if (lengthLimit <= 0) {
      _packageLengthLimit = -1;
    } else {
      _packageLengthLimit = math.max(lengthLimit, minPackageLength);
    }
  }

  bool _isConnected() {
    return device.isConnected;
  }

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

  Future<void> _requestDeviceWifiScan() async {
    final type = _getTypeValue(BlufiParameter.typeCtrlPackageValue, BlufiParameter.typeCtrlSubTypeGetWifiList);
    var request = false;

    try {
      request = await _post(_encrypted, _checksum, _requireAck, type, null);
    } catch (err) {
      _printLog('post requestDeviceWifiScan interrupted');
    }

    if (!request) {
      _blufiUserCallback?.onDeviceScanResult(this, BlufiCallback.codeWriteDataFailed, []);
    }
  }

  int _getTypeValue(int type, int subType) {
    return (subType << 2) | type;
  }

  int _getPakcageType(int typeValue) {
    return typeValue & int.parse('11', radix: 2);
  }

  int _getSubType(int typeValue) {
    return (typeValue & int.parse('11111100', radix: 2)) >> 2;
  }

  Future<bool> _post(bool encrypt, bool checksum, bool requireAck, int type, BlufiBytes? data) {
    if (data == null || data.isEmpty) {
      return _postNonData(encrypt, checksum, requireAck, type);
    } else {
      return _postContainData(encrypt, checksum, requireAck, type, data);
    }
  }

  Future<bool> _postNonData(bool encrypt, bool checksum, bool requireAck, int type) async {
    final sequence = _generateSendSequence();
    final postBytes = _getPostBytes(type, encrypt, checksum, requireAck, false, sequence, null);
    final posted = await _gattWrite(postBytes);

    if (requireAck) {
      final success = await _receiveAck(sequence);
      if (!success) {
        return false;
      }
    }

    return posted;
  }

  Future<bool> _postContainData(bool encrypt, bool checksum, bool requireAck, int type, BlufiBytes data) async {
    final dataIS = BlufiBytesInputStream(bytes: data);
    final dataContent = BlufiBytesOutputStream();
    final pkgLengthLimit =
        _packageLengthLimit > 0 ? _packageLengthLimit : (_blufiMtu > 0 ? _blufiMtu : defaultPackageLength);
    var postDataLengthLimit = pkgLengthLimit - packageHeaderLength;
    postDataLengthLimit -= 2;
    if (checksum) {
      postDataLengthLimit -= 2;
    }

    final dataBuf = BlufiBytes(length: postDataLengthLimit);

    while (true) {
      var read = dataIS.readAndCopy(dataBuf, 0, dataBuf.length);
      if (read == -1) {
        break;
      }

      dataContent.copyAndWrite(dataBuf, 0, read);
      if (dataIS.available() > 2 && dataIS.available() <= 2) {
        read = dataIS.readAndCopy(dataBuf, 0, dataIS.available());
        dataContent.copyAndWrite(dataBuf, 0, read);
      }

      final frag = dataIS.available() > 0;
      final sequence = _generateSendSequence();
      if (frag) {
        final totalLen = dataContent.size() + dataIS.available();
        final tempData = dataContent.toBytes();
        dataContent
          ..reset()
          ..write(totalLen & 0xff)
          ..write(totalLen >> 8 & 0xff)
          ..copyAndWrite(tempData, 0, tempData.length);
      }
      final postBytes = _getPostBytes(type, encrypt, checksum, requireAck, frag, sequence, dataContent.toBytes());
      dataContent.reset();
      final posted = await _gattWrite(postBytes);
      if (!posted) {
        return false;
      }
      if (frag) {
        if (requireAck) {
          final success = await _receiveAck(sequence);
          if (!success) {
            return false;
          }
        }
        await Future<void>.delayed(const Duration(milliseconds: 10));
      } else {
        if (requireAck) {
          return _receiveAck(sequence);
        } else {
          return true;
        }
      }
    }

    return true;
  }

  BlufiBytes _getPostBytes(
    int type,
    bool encrypt,
    bool checksum,
    bool requireAck,
    bool hasFrag,
    int sequence,
    BlufiBytes? data,
  ) {
    final dataLength = data == null ? 0 : data.length;
    final frameCtrl = BlufiFrameCtrlData.getFrameCtrlValue(
      encrypt,
      checksum,
      BlufiParameter.directionOutput,
      requireAck,
      hasFrag,
    );
    final postBytes = <int>[
      type,
      frameCtrl,
      sequence,
      dataLength,
    ];

    var checksumBytes = <int>[];
    if (checksum) {
      final willCheckBytes = [sequence, dataLength];
      var crc = BlufiCrc.calcCrc(0, willCheckBytes);
      if (dataLength > 0) {
        crc = BlufiCrc.calcCrc(crc, data!.values);
      }
      checksumBytes = <int>[(crc & 0xff), (crc >> 8 & 0xff)];
    }

    if (encrypt && dataLength > 0) {
      // TODO: encrypt
    }

    if (dataLength > 0) {
      postBytes.addAll(data!.values);
    }

    if (checksumBytes.isNotEmpty) {
      postBytes
        ..add(checksumBytes[0])
        ..add(checksumBytes[1]);
    }

    return BlufiBytes.fromList(postBytes);
  }

  Future<bool> _gattWrite(BlufiBytes bytes) async {
    if (!_isConnected()) {
      return false;
    }

    _printLog('gattWrite= $bytes');

    if (_writeTimeout > 0) {
      await _writeChar.write(bytes.values, timeout: _writeTimeout);
    } else {
      await _writeChar.write(bytes.values);
    }

    return true;
  }

  Future<bool> _receiveAck(int expectAck) async {
    late Timer timeout;
    final completer = Completer<bool>();
    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (completer.isCompleted) {
        return;
      }

      final success = _receiveAckInQueue(expectAck);
      if (success) {
        timeout.cancel();
        completer.complete(true);
      }
    });
    timeout = Timer(const Duration(seconds: 5), () {
      if (!completer.isCompleted) {
        timer.cancel();
        completer.complete(false);
      }
    });

    return completer.future;
  }

  bool _receiveAckInQueue(int expectAck) {
    if (_ack.isEmpty) {
      return false;
    }

    final i = _ack.indexOf(expectAck);

    if (i >= 0) {
      _ack.removeAt(i);
      return true;
    }

    return false;
  }

  int _generateSendSequence() {
    return ++_sendSequence & 0xff;
  }

  void _onNotificationReceived(List<int> response) {
    _notifyData ??= BlufiNotifyData();
    final data = BlufiBytes.fromList(response);
    _printLog('Gatt Notification: $data');

    final parse = _parseNotification(data, _notifyData!);
    if (parse < 0) {
      _blufiUserCallback?.onError(this, BlufiCallback.codeInvalidNotification);
    } else if (parse == 0) {
      _parseBlufiNotifyData(_notifyData!);
      _notifyData = null;
    }
  }

  int _parseNotification(BlufiBytes data, BlufiNotifyData notification) {
    if (data.isEmpty) {
      return -1;
    }
    if (data.length < 4) {
      return -2;
    }

    final sequence = data.get(2);
    final readSequence = ++_readSequence & 0xff;
    if (sequence != readSequence) {
      return -3;
    }

    final type = data.get(0);
    final pkgType = _getPakcageType(type);
    final subType = _getSubType(type);

    notification
      ..typeValue = type
      ..pkgType = pkgType
      ..subType = subType;

    final frameCtrl = data.get(1);
    notification.frameCtrlValue = frameCtrl;
    final frameCtrlData = BlufiFrameCtrlData(value: frameCtrl);

    final dataLen = data.get(3);
    var dataOffset = 4;
    final dataBytes = <int>[];

    for (var i = dataOffset; i < dataOffset + dataLen; i++) {
      dataBytes.add(data.get(i));
    }

    if (frameCtrlData.isEncrypted()) {
      // TODO;
    }

    if (frameCtrlData.isChecksum()) {
      final respChecksum1 = data.get(data.length - 1);
      final respChecksum2 = data.get(data.length - 2);

      var crc = BlufiCrc.calcCrc(0, [sequence, dataLen]);
      crc = BlufiCrc.calcCrc(crc, dataBytes);
      final calcChecksum1 = crc >> 8 & 0xff;
      final calcChecksum2 = crc & 0xff;

      if (respChecksum1 != calcChecksum1 || respChecksum2 != calcChecksum2) {
        return -4;
      }
    }

    if (frameCtrlData.hasFrag()) {
      dataOffset = 2;
    } else {
      dataOffset = 0;
    }
    notification.addData(Uint8List.fromList(dataBytes), dataOffset);

    return frameCtrlData.hasFrag() ? 1 : 0;
  }

  void _parseBlufiNotifyData(BlufiNotifyData data) {
    final pkgType = data.pkgType;
    final subType = data.subType;
    final dataBytes = data.dataBytes;

    switch (pkgType) {
      case BlufiParameter.typeCtrlPackageValue:
        _parseCtrlData(subType, dataBytes);
        break;
      case BlufiParameter.typeDataPackageValue:
        _parseDataData(subType, dataBytes);
        break;
      default:
        break;
    }
  }

  void _parseCtrlData(int subType, BlufiBytes data) {
    if (subType == BlufiParameter.typeCtrlSubTypeAck) {
      _parseAck(data);
    }
  }

  void _parseAck(BlufiBytes bytes) {
    var ack = 0x100;
    if (bytes.isNotEmpty) {
      ack = bytes.get(0) & 0xff;
    }
    _ack.add(ack);
  }

  void _parseDataData(int subType, BlufiBytes data) {
    switch (subType) {
      case BlufiParameter.typeDataSubTypeNeg:
        // TODO:
        break;
      case BlufiParameter.typeDataSubTypeVersion:
        // TODO:
        break;
      case BlufiParameter.typeDataSubTypeWifiConnectionState:
        break;
      case BlufiParameter.typeDataSubTypeWifiList:
        _parseWifiScanList(data);
        break;
      case BlufiParameter.typeDataSubTypeCustomData:
        // TODO:
        break;
      case BlufiParameter.typeDataSubTypeError:
        {
          final errCode = data.isNotEmpty ? (data.get(0) & 0xff) : 0xff;
          _blufiUserCallback?.onError(this, errCode);
          break;
        }
      default:
        break;
    }
  }

  void _parseWifiScanList(BlufiBytes bytes) {
    if (bytes.length < 2) {
      return;
    }

    final results = <BlufiScanResult>[];
    final dataReader = BlufiBytesInputStream(bytes: bytes);
    while (dataReader.available() > 0) {
      final length = dataReader.read() & 0xff;
      if (length < 1) {
        break;
      }

      final rssi = dataReader.read();
      final ssidBytes = BlufiBytes(length: length - 1);
      final ssidRead = dataReader.readAndCopy(ssidBytes, 0, ssidBytes.length);

      if (ssidRead != ssidBytes.length) {
        break;
      }

      final result = BlufiScanResult()
        ..type = BlufiScanResult.typeWifi
        ..rssi = rssi - 256
        ..ssid = ssidBytes.toString();

      results.add(result);
    }

    _blufiUserCallback?.onDeviceScanResult.call(
      this,
      0,
      results,
    );
  }

  void _printLog(String message) {
    if (_printDebug) {
      // ignore: avoid_print
      print('$message\n');
    }
  }
}
