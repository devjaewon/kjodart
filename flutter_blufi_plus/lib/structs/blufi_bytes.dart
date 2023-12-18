part of flutter_blufi_plus;

// bytes handling for blufi
class BlufiBytes {
  BlufiBytes({
    Uint8List? bytes,
    int? length,
  }) : _bytes = createInitialBytes(bytes, length);

  factory BlufiBytes.empty() {
    return BlufiBytes();
  }

  factory BlufiBytes.fromList(List<int> data) {
    return BlufiBytes(bytes: Uint8List.fromList(data));
  }

  factory BlufiBytes.copy(BlufiBytes other) {
    final byteValues = Uint8List(other.length);
    for (var i = 0; i < other.length; i++) {
      byteValues[i] = other.get(i);
    }

    return BlufiBytes(bytes: byteValues);
  }
  
  final Uint8List _bytes;

  static Uint8List createInitialBytes(Uint8List? bytes, int? length) {
    if (length == null) {
      if (bytes == null) {
        return Uint8List(0);
      } else {
        return bytes;
      }
    }
    if (bytes == null) {
      return Uint8List(length);
    }
    
    final newBytes = Uint8List(length);

    for (var i = 0; i < length; i++) {
      if (i >= newBytes.length) {
        break;
      }
      newBytes[i] = bytes[i];
    }

    return newBytes;
  }

  int get length => _bytes.length;

  bool get isEmpty => _bytes.isEmpty;

  bool get isNotEmpty => _bytes.isNotEmpty;

  Uint8List get values => _bytes;

  int get(int offset) {
    if (offset < 0 || offset > _bytes.length - 1) {
      throw Error();
    }

    return _bytes[offset];
  }

  void set(int offset, int value) {
    if (_bytes.length + 1 < offset) {
      final need = offset - _bytes.length + 1;

      for (var i = 0; i < need; i++) {
        _bytes.add(0);
      }
    }

    _bytes[offset] = value;
  }

  void reset() {
    _bytes.clear();
  }

  int getMaskingByte(int offset) {
    return get(offset) & 0xff;
  }

  void append(int byte) {
    _bytes.add(byte);
  }

  void appendList(List<int> newBytes, {int offset = 0}) {
    for (var i = offset; i < newBytes.length; i++) {
      _bytes.add(newBytes[i]);
    }
  }

  String toHex() {
    final sb = StringBuffer();

    for (final b in _bytes) {
      final number = b & 0xff;
      final str = number.toRadixString(16);

      if (str.length == 1) {
        sb.write('0');
      }
      sb.write(str);
    }

    return sb.toString();
  }

  @override
  String toString() {
    final sb = StringBuffer();

    for (final b in _bytes) {
      sb.writeCharCode(b);
    }

    return sb.toString();
  }
}
