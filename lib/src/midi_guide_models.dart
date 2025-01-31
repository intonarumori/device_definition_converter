class MidiGuideParameter {
  static const columnNameManufacturer = 'manufacturer';
  static const columnNameDevice = 'device';
  static const columnNameSection = 'section';
  static const columnNameParameterName = 'parameter_name';
  static const columnNameDescription = 'parameter_description';
  static const columnNameCcMsb = 'cc_msb';
  static const columnNameCcLsb = 'cc_lsb';
  static const columnNameCcMinValue = 'cc_min_value';
  static const columnNameCcMaxValue = 'cc_max_value';
  static const columnNameNrpnMsb = 'nrpn_msb';
  static const columnNameNrpnLsb = 'nrpn_lsb';
  static const columnNameNrpnMinValue = 'nrpn_min_value';
  static const columnNameNrpnMaxValue = 'nrpn_max_value';
  static const columnNamerientation = 'orientation';
  static const columnNameNotes = 'notes';
  static const columnNameUsage = 'usage';
  static const columnNameAbbreviation = 'abbreviation';

  final String? manufacturer;
  final String? device;
  final String? section;
  final String parameterName;
  final String? parameterDescription;
  final int? ccMsb;
  final int? ccLsb;
  final int? ccMinValue;
  final int? ccMaxValue;
  final int? nrpnMsb;
  final int? nrpnLsb;
  final int? nrpnMinValue;
  final int? nrpnMaxValue;
  final String? notes;
  final String? usage;
  final String? abbreviation;

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
    required this.abbreviation,
  });

  static MidiGuideParameter fromList(List<String> header, List<dynamic> list) {
    try {
      return MidiGuideParameter(
          manufacturer: _getParameter<String>(header, list, columnNameManufacturer),
          device: _getParameter<String>(header, list, columnNameDevice),
          section: _getParameter<String>(header, list, columnNameSection),
          parameterName: _getParameter<String>(header, list, columnNameParameterName)!,
          parameterDescription: _getParameter<String>(header, list, columnNameDescription),
          ccMsb: _getParameter<int>(header, list, columnNameCcMsb),
          ccLsb: _getParameter<int>(header, list, columnNameCcLsb),
          ccMinValue: _getParameter<int>(header, list, columnNameCcMinValue),
          ccMaxValue: _getParameter<int>(header, list, columnNameCcMaxValue),
          nrpnMsb: _getParameter<int>(header, list, columnNameNrpnMsb),
          nrpnLsb: _getParameter<int>(header, list, columnNameNrpnLsb),
          nrpnMinValue: _getParameter<int>(header, list, columnNameNrpnMinValue),
          nrpnMaxValue: _getParameter<int>(header, list, columnNameNrpnLsb),
          notes: _getParameter<String>(header, list, columnNameNotes),
          usage: _getParameter<String>(header, list, columnNameUsage),
          abbreviation: _getParameter<String>(header, list, columnNameAbbreviation));
    } catch (e) {
      rethrow;
    }
  }

  static T? _getParameter<T>(List<String> header, List<dynamic> data, String name) {
    final index = header.indexOf(name);
    if (index >= 0) {
      if (index >= data.length) {
        // throw Exception(
        //     'Data row (${data.length}) is shorter than header (${header.length}): $header <> $data');
        return null;
      }
      final d = data[index];
      if (T == int) {
        try {
          return parseInt(d) as T;
        } catch (e) {
          //print(' null $name');
          return null;
        }
      }
      return d;
    }
    return null;
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
      abbreviation: map['Abbreviation'],
    );
  }

  @override
  String toString() {
    return 'MidiGuideParameter: $parameterName';
  }
}
