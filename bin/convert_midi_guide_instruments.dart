import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:device_definition_converter/src/device_definition_serializer.dart';
import 'package:device_definition_converter/src/device_entry.dart';
import 'package:device_definition_converter/src/midi_guide_to_device_definitions.dart';

void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', defaultsTo: null, help: 'Input directory')
    ..addOption('output', abbr: 'o', defaultsTo: null, help: 'Output directory');

  final results = parser.parse(args);
  final input = results['input'] ?? (throw ArgumentError('Input directory is required'));
  final output = results['output'] ?? (throw ArgumentError('Output directory is required'));

  if (!await Directory(input).exists()) {
    throw ArgumentError('Input directory does not exist');
  }
  if (!await Directory(output).exists()) {
    throw ArgumentError('Output directory does not exist');
  }
  _convertDevices(input, output);
}

Future<void> _convertDevices(String input, String output) async {
  final paths = await _collectPaths(Directory(input));

  final List<DeviceEntry> devices = [];

  for (final path in paths) {
    try {
      if (!_isDevicePath(path)) continue;
      final deviceEntry = await _convertDevice(path, output);
      devices.add(deviceEntry);
    } catch (e) {
      print('Malformatted csv file: $path');
    }
  }

  // Write catalog
  final devicesMap = devices.map((e) => e.asMap()).toList();
  final devicesFilename = 'devices.json';
  final devicesOutputPath = '$output/$devicesFilename';
  await File(devicesOutputPath).writeAsString(jsonEncode(devicesMap));
}

Future<DeviceEntry> _convertDevice(String input, String output) async {
  final manufacturer = _getManufacturer(input);
  final deviceName = _getDeviceName(input);

  final string = await File(input).readAsString();
  final parameters = await MidiGuideToDeviceDefinitions.readParametersFromCSV(string);

  final deviceDefinition = await MidiGuideToDeviceDefinitions.convert(
    parameters,
    manufacturer,
    deviceName,
  );

  print('Converted: $manufacturer $deviceName -> ${deviceDefinition.abbr}');

  // Write device
  final map = DeviceDefinitionSerializer.toMap(deviceDefinition);
  final filename = '${deviceDefinition.id}.json';
  final outputPath = '$output/$filename';
  var encoder = JsonEncoder.withIndent('\t');
  String prettyJson = encoder.convert(map);
  await File(outputPath).writeAsString(prettyJson);

  return DeviceEntry(
    manufacturer: deviceDefinition.manufacturer,
    model: deviceDefinition.name,
    file: filename,
  );
}

// Helpers

String _getManufacturer(String path) {
  final parts = path.split('/');
  if (parts.length < 2) {
    return '';
  }
  return parts[parts.length - 2];
}

String _getDeviceName(String path) {
  final parts = path.split('/');
  if (parts.isEmpty) {
    return '';
  }
  return parts.last.split('.').first;
}

bool _isDevicePath(String path) {
  // Only consider the right depth for folders
  return path.split('/').length >= 3;
}

Future<List<String>> _collectPaths(Directory directory) async {
  final List<String> paths = [];

  final files = await directory.list().toList();
  for (final file in files) {
    if (file is File && file.path.endsWith('.csv')) {
      paths.add(file.path);
    } else if (file is Directory) {
      paths.addAll(await _collectPaths(file));
    }
  }

  return paths;
}
