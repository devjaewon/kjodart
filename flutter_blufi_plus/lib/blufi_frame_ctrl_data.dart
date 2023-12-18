part of flutter_blufi_plus;

class BlufiFrameCtrlData {
  BlufiFrameCtrlData({
    required this.value,
  });

  static const int frameCtrlPositionEncrypted = 0;

  static const int frameCtrlPositionChecksum = 1;

  static const int frameCtrlPositionDataDirection = 2;

  static const int frameCtrlPositionRequireAck = 3;

  static const int frameCtrlPositionFrag = 4;

  static int getFrameCtrlValue(
    bool encrypted,
    bool checksum,
    int direction,
    bool requireAck,
    bool frag,
  ) {
    var frame = 0;
    
    if (encrypted) {
      frame = frame | (1 << frameCtrlPositionEncrypted);
    }
    if (checksum) {
      frame = frame | (1 << frameCtrlPositionChecksum);
    }
    if (direction == BlufiParameter.directionInput) {
      frame = frame | (1 << frameCtrlPositionDataDirection);
    }
    if (requireAck) {
      frame = frame | (1 << frameCtrlPositionRequireAck);
    }
    if (frag) {
      frame = frame | (1 << frameCtrlPositionFrag);
    }

    return frame;
  }

  final int value;

  bool _check(int position) {
    return ((value >> position) & 1) == 1;
  }

  bool isEncrypted() {
    return _check(frameCtrlPositionEncrypted);
  }

  bool isChecksum() {
    return _check(frameCtrlPositionChecksum);
  }

  bool isAckRequirement() {
    return _check(frameCtrlPositionRequireAck);
  }

  bool hasFrag() {
    return _check(frameCtrlPositionFrag);
  }
}