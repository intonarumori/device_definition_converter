class DeviceDefinition {
  final String id;
  final String name;
  final String manufacturer;
  final String abbr;
  final List<DeviceParameter> parameters;
  final String? script;

  const DeviceDefinition({
    required this.id,
    required this.name,
    required this.abbr,
    required this.manufacturer,
    required this.parameters,
    required this.script,
  });

  factory DeviceDefinition.empty() {
    return const DeviceDefinition(
      id: '',
      abbr: 'new',
      name: 'New Instrument',
      manufacturer: '',
      parameters: [
        DeviceParameter(
          type: DeviceParameterControlType.cc,
          name: 'Control',
          abbr: 'ctrl',
          minimum: 0,
          maximum: 127,
          defaultValue: 0,
        )
      ],
      script: null,
    );
  }

  copyWith({
    String? id,
    String? name,
    String? abbr,
    String? manufacturer,
    List<DeviceParameter>? parameters,
    String? script,
  }) {
    return DeviceDefinition(
      id: id ?? this.id,
      name: name ?? this.name,
      abbr: abbr ?? this.abbr,
      manufacturer: manufacturer ?? this.manufacturer,
      parameters: parameters ?? this.parameters,
      script: script ?? this.script,
    );
  }
}

enum DeviceParameterControlType {
  cc('cc'),
  cc14('cc14'),
  nrpn('nrpn'),
  script('script');

  final String value;
  const DeviceParameterControlType(this.value);

  factory DeviceParameterControlType.from(String value) {
    return values.firstWhere((e) => e.value == value);
  }

  String get name => value.toUpperCase();
}

class DeviceParameter {
  final String name;
  final String abbr;
  final int minimum;
  final int maximum;
  final int defaultValue;
  final DeviceParameterControlType type;
  final int? nr1;
  final int? nr2;
  final List<DeviceDefinitionValueLabel> valueLabels;

  const DeviceParameter({
    required this.type,
    required this.name,
    required this.abbr,
    required this.minimum,
    required this.maximum,
    required this.defaultValue,
    this.nr1,
    this.nr2,
    this.valueLabels = const [],
  });

  copyWith({
    DeviceParameterControlType? type,
    String? name,
    String? abbr,
    int? minimum,
    int? maximum,
    int? defaultValue,
    int? nr1,
    int? nr2,
    List<DeviceDefinitionValueLabel>? valueLabels,
  }) {
    return DeviceParameter(
      type: type ?? this.type,
      name: name ?? this.name,
      abbr: abbr ?? this.abbr,
      minimum: minimum ?? this.minimum,
      maximum: maximum ?? this.maximum,
      defaultValue: defaultValue ?? this.defaultValue,
      nr1: nr1 ?? this.nr1,
      nr2: nr2 ?? this.nr2,
      valueLabels: valueLabels ?? this.valueLabels,
    );
  }

  factory DeviceParameter.defaultCC() {
    return const DeviceParameter(
      type: DeviceParameterControlType.cc,
      name: 'Control',
      abbr: 'ctrl',
      minimum: 0,
      maximum: 127,
      defaultValue: 64,
    );
  }
}

class DeviceDefinitionValueLabel {
  final int value;
  final String label;

  const DeviceDefinitionValueLabel({
    required this.value,
    required this.label,
  });

  @override
  String toString() {
    return 'DeviceDefinitionValueLabel(value:$value, label:$label)';
  }
}
