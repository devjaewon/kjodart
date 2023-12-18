part of flutter_blufi_plus;

class BlufiBytesOutputStream {
  BlufiBytesOutputStream({
    BlufiBytes? bytes,
  }) : _bytes = bytes == null ? BlufiBytes.empty() : BlufiBytes.copy(bytes);

  final BlufiBytes _bytes;

  int size() {
    return _bytes.length;
  }

  void write(int value) {
    _bytes.append(value);
  }

  void copyAndWrite(BlufiBytes otherBytes, int offset, int length) {
    for (var i = offset; i < offset + length; i++) {
      write(otherBytes.get(i));
    }
  }

  void reset() {
    _bytes.reset();
  }

  BlufiBytes toBytes() {
    return BlufiBytes.copy(_bytes);
  }
}
