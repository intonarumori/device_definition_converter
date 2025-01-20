import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:instrument_definition_converter/device_definition_serializer.dart';
import 'package:instrument_definition_converter/device_entry.dart';
import 'package:instrument_definition_converter/midi_guide_to_device_definitions.dart';

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

  final paths = await collectPaths(Directory(input));

  final List<DeviceEntry> devices = [];

  for (final path in paths) {
    try {
      if (!isDevicePath(path)) continue;

      final manufacturer = _getManufacturer(path);
      final deviceName = _getDeviceName(path);

      final parameters = await MidiGuideToDeviceDefinitions.readParametersFromCSV(path);

      final deviceDefinition = await MidiGuideToDeviceDefinitions.convert(
        parameters,
        manufacturer,
        deviceName,
      );

      final map = DeviceDefinitionSerializer.toMap(deviceDefinition);
      final filename = '${deviceDefinition.id}.json';
      final outputPath = '$output/$filename';
      await File(outputPath).writeAsString(jsonEncode(map));

      devices.add(DeviceEntry(
        manufacturer: deviceDefinition.manufacturer,
        model: deviceDefinition.name,
        file: filename,
      ));
    } catch (e) {
      print('Malformatted csv file: $path');
    }
  }

  // Write catalog
  final devicesMap = devices.map((e) => e.asMap()).toList();
  final devicesFilename = 'devices.json';
  final devicesOutputPath = '$output/$devicesFilename';
  await File(devicesOutputPath).writeAsString(jsonEncode(devicesMap));

  //print('Dict ${dictionary.length} words ${dictionary.toList()..sort((a, b) => a.compareTo(b))}');
}

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

bool isDevicePath(String path) {
  // Only consider the right depth for folders
  return path.split('/').length >= 3;
}

Future<List<String>> collectPaths(Directory directory) async {
  final List<String> paths = [];

  final files = await directory.list().toList();
  for (final file in files) {
    if (file is File && file.path.endsWith('.csv')) {
      paths.add(file.path);
    } else if (file is Directory) {
      paths.addAll(await collectPaths(file));
    }
  }

  return paths;
}
