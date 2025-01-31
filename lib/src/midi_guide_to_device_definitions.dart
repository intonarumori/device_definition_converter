import 'package:csv/csv.dart';
import 'device_definition.dart';
import 'midi_guide_models.dart';
import 'naming.dart';

class MidiGuideToDeviceDefinitions {
  static DeviceDefinition convert(
    List<MidiGuideParameter> parameters,
    String? manufacturer,
    String deviceName,
  ) {
    final List<DeviceParameter> deviceParameters = [];
    for (final parameter in parameters) {
      try {
        final deviceParameter = createDeviceParameter(parameter);
        deviceParameters.add(deviceParameter);
      } catch (e) {
        print('Error creating parameter: ${manufacturer} ${deviceName} ${parameter.parameterName}');
      }
    }

    final deviceDefinition = DeviceDefinition(
      id: Naming.createId('${manufacturer}_$deviceName'),
      name: deviceName,
      abbr: Naming.abbreviatedName('${manufacturer} $deviceName'),
      manufacturer: manufacturer ?? '',
      parameters: deviceParameters,
      script: null,
    );
    return deviceDefinition;
  }

  static Future<List<MidiGuideParameter>> readParametersFromCSV(String data) async {
    final converter = CsvToListConverter(eol: '\n');
    final csv = converter.convert(data);
    final header = csv[0].cast<String>();
    final dataRows = csv.sublist(1);
    final result = dataRows.map((e) => MidiGuideParameter.fromList(header, e)).toList();
    return result;
  }

  static DeviceParameter createDeviceParameter(MidiGuideParameter parameter) {
    if (parameter.ccMsb != null) {
      if (parameter.ccLsb != null) {
        return DeviceParameter(
          type: DeviceParameterControlType.cc14,
          name: parameter.parameterName,
          abbr: parameter.abbreviation ?? Naming.createAbbreviation(parameter.parameterName),
          minimum: parameter.ccMinValue ?? 0,
          maximum: parameter.ccMaxValue ?? 16383,
          nr1: parameter.ccLsb,
          nr2: parameter.ccMsb,
          defaultValue: 0,
        );
      } else {
        return DeviceParameter(
          type: DeviceParameterControlType.cc,
          name: parameter.parameterName,
          abbr: parameter.abbreviation ?? Naming.createAbbreviation(parameter.parameterName),
          minimum: parameter.ccMinValue ?? 0,
          maximum: parameter.ccMaxValue ?? 127,
          nr1: parameter.ccMsb,
          nr2: 0,
          defaultValue: 0,
        );
      }
    }
    if (parameter.nrpnLsb != null && parameter.nrpnMsb != null) {
      return DeviceParameter(
        type: DeviceParameterControlType.nrpn,
        name: parameter.parameterName,
        abbr: parameter.abbreviation ?? Naming.createAbbreviation(parameter.parameterName),
        minimum: parameter.nrpnMinValue ?? 0,
        maximum: parameter.nrpnMaxValue ?? 127,
        nr1: parameter.nrpnLsb,
        nr2: parameter.nrpnMsb,
        defaultValue: 0,
      );
    }
    throw ArgumentError('Parameter does not have a valid control type');
  }
}
