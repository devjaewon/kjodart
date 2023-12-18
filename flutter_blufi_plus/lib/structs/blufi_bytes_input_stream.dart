part of flutter_blufi_plus;

class BlufiBytesInputStream {
  BlufiBytesInputStream({
    BlufiBytes? bytes,
  })  : _bytes = bytes == null ? BlufiBytes.empty() : BlufiBytes.copy(bytes),
        _cursor = (bytes == null || bytes.isEmpty) ? -1 : 0;

  final BlufiBytes _bytes;
  int _cursor;

  int available() {
    if (_isOutOfRange(_cursor)) {
      return 0;
    }

    return _bytes.length - _cursor + 1;
  }

  int read() {
    if (_isOutOfRange(_cursor)) {
      return -1;
    }

    final value = _bytes.get(_cursor);
    _cursor++;

    return value;
  }

  int readAndCopy(BlufiBytes newBytes, int offset, int length) {
    var readCount = -1;
    var newBytesOffset = offset;
    for (var i = 0; i < length; i++) {
      final result = read();

      if (result != -1) {
        if (readCount < 0) {
          readCount = 1;
        } else {
          readCount++;
        }
        newBytes.set(newBytesOffset, result);
      } else {
        break;
      }

      newBytesOffset++;
    }

    return readCount;
  }

  bool _isOutOfRange(int cursor) {
    return cursor < 0 || cursor > _bytes.length - 1;
  }
}
