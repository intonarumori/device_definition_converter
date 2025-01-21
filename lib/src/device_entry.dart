class DeviceEntry {
  final String manufacturer;
  final String model;
  final String file;

  const DeviceEntry({
    required this.manufacturer,
    required this.model,
    required this.file,
  });

  Map<String, dynamic> asMap() {
    return {
      'manufacturer': manufacturer,
      'model': model,
      'file': file,
    };
  }
}
