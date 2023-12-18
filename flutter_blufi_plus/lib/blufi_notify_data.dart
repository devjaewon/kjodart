part of flutter_blufi_plus;

class BlufiNotifyData {
  BlufiNotifyData() : dataOs = BlufiBytesOutputStream();

  int typeValue = 0;

  int pkgType = 0;

  int subType = 0;

  int frameCtrlValue = 0;

  final BlufiBytesOutputStream dataOs;

  get dataBytes {
    return dataOs.toBytes();
  }

  void addData(Uint8List bytes, int offset) {
    dataOs.copyAndWrite(BlufiBytes(bytes: bytes), offset, bytes.length - offset);
  }
}
