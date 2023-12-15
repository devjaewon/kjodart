part of flutter_blufi_plus;

class BlufiVersionResponse {
  final List<int> versionValues = [0, 0];

  void setVersionValues(int bigVer, int smallVer) {
    versionValues[0] = bigVer;
    versionValues[1] = smallVer;
  }

  String get versionString {
    return 'V${versionValues[0]}.${versionValues[1]}';
  }
}
