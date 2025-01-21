class MidiGuideParameter {
  final String manufacturer;
  final String device;
  final String section;
  final String parameterName;
  final String parameterDescription;
  final int? ccMsb;
  final int? ccLsb;
  final int? ccMinValue;
  final int? ccMaxValue;
  final int? nrpnMsb;
  final int? nrpnLsb;
  final int? nrpnMinValue;
  final int? nrpnMaxValue;
  final String notes;
  final String usage;

  const MidiGuideParameter({
    required this.manufacturer,
    required this.device,
    required this.section,
    required this.parameterName,
    required this.parameterDescription,
    required this.ccMsb,
    required this.ccLsb,
    required this.ccMinValue,
    required this.ccMaxValue,
    required this.nrpnMsb,
    required this.nrpnLsb,
    required this.nrpnMinValue,
    required this.nrpnMaxValue,
    required this.notes,
    required this.usage,
  });

  static MidiGuideParameter fromList(List<dynamic> list) {
    return MidiGuideParameter(
      manufacturer: list[0],
      device: list[1],
      section: list[2],
      parameterName: list[3],
      parameterDescription: list[4],
      ccMsb: parseInt(list[5]),
      ccLsb: parseInt(list[6]),
      ccMinValue: parseInt(list[7]),
      ccMaxValue: parseInt(list[8]),
      nrpnMsb: parseInt(list[9]),
      nrpnLsb: parseInt(list[10]),
      nrpnMinValue: parseInt(list[11]),
      nrpnMaxValue: parseInt(list[12]),
      notes: list[13],
      usage: list[14],
    );
  }

  static int? parseInt(dynamic value) {
    if (value == "") return null;
    return value is int ? value : int.parse(value);
  }

  static MidiGuideParameter fromMap(Map<String, dynamic> map) {
    return MidiGuideParameter(
      manufacturer: map['Manufacturer'],
      device: map['Device'],
      section: map['Section'],
      parameterName: map['Parameter Name'],
      parameterDescription: map['Parameter Description'],
      ccMsb: int.parse(map['CC MSB']),
      ccLsb: int.parse(map['CC LSB']),
      ccMinValue: int.parse(map['CC Min Value']),
      ccMaxValue: int.parse(map['CC Max Value']),
      nrpnMsb: int.parse(map['NRPN MSB']),
      nrpnLsb: int.parse(map['NRPN LSB']),
      nrpnMinValue: int.parse(map['NRPN Min Value']),
      nrpnMaxValue: int.parse(map['NRPN Max Value']),
      notes: map['Notes'],
      usage: map['Usage'],
    );
  }

  @override
  String toString() {
    return 'MidiGuideParameter: $parameterName';
  }
}
