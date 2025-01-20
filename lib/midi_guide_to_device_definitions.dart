import 'dart:io';

import 'package:csv/csv.dart';
import 'package:instrument_definition_converter/device_definition.dart';
import 'package:instrument_definition_converter/midi_guide_models.dart';
import 'package:instrument_definition_converter/naming.dart';

class MidiGuideToDeviceDefinitions {
  static Future<DeviceDefinition> convert(String path) async {
    final manufacturer = _getManufacturer(path);
    final deviceName = _getDeviceName(path);

    final parameters = await parseCsv(path);

    final List<DeviceParameter> deviceParameters = [];
    for (final parameter in parameters) {
      try {
        final deviceParameter = createDeviceParameter(parameter);
        deviceParameters.add(deviceParameter);
      } catch (e) {
        print('Error creating parameter: ${parameter.parameterName}');
      }
    }

    final deviceDefinition = DeviceDefinition(
      id: Naming.createId('${manufacturer}_$deviceName'),
      name: deviceName,
      abbr: Naming.abbreviatedName(manufacturer),
      manufacturer: manufacturer,
      parameters: deviceParameters,
      script: null,
    );
    return deviceDefinition;
  }

  static String _getManufacturer(String path) {
    final parts = path.split('/');
    if (parts.length < 2) {
      return '';
    }
    return parts[parts.length - 2];
  }

  static String _getDeviceName(String path) {
    final parts = path.split('/');
    if (parts.isEmpty) {
      return '';
    }
    return parts.last.split('.').first;
  }

  static Future<List<MidiGuideParameter>> parseCsv(String path) async {
    final string = await File(path).readAsString();
    final converter = CsvToListConverter(eol: '\n');
    final csv = converter.convert(string);
    final result = csv.sublist(1).map((e) => MidiGuideParameter.fromList(e)).toList();
    return result;
  }

  static DeviceParameter createDeviceParameter(MidiGuideParameter parameter) {
    if (parameter.ccMsb != null) {
      if (parameter.ccLsb != null) {
        return DeviceParameter(
          type: DeviceParameterControlType.cc14,
          name: parameter.parameterName,
          abbr: Naming.createAbbreviation(parameter.parameterName),
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
          abbr: Naming.createAbbreviation(parameter.parameterName),
          minimum: parameter.ccMinValue ?? 0,
          maximum: parameter.ccMaxValue ?? 127,
          nr1: parameter.ccLsb,
          nr2: parameter.ccMsb,
          defaultValue: 0,
        );
      }
    }
    if (parameter.nrpnLsb != null && parameter.nrpnMsb != null) {
      return DeviceParameter(
        type: DeviceParameterControlType.nrpn,
        name: parameter.parameterName,
        abbr: Naming.createAbbreviation(parameter.parameterName),
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
