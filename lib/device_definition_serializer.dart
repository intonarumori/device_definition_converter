import 'package:instrument_definition_converter/device_definition.dart';

extension DeviceDefinitionSerializer on DeviceDefinition {
  static Map<String, dynamic> toMap(DeviceDefinition deviceDefinition) {
    return {
      'id': deviceDefinition.id,
      'name': deviceDefinition.name,
      'abbr': deviceDefinition.abbr,
      'manufacturer': deviceDefinition.manufacturer,
      'parameters': deviceDefinition.parameters
          .map((e) => DeviceParameterSerializer.toMap(e))
          .toList(),
      'script': deviceDefinition.script,
    };
  }
}

extension DeviceParameterSerializer on DeviceParameter {
  static Map<String, dynamic> toMap(DeviceParameter deviceParameter) {
    return {
      'type': deviceParameter.type.value,
      'name': deviceParameter.name,
      'abbr': deviceParameter.abbr,
      'minimum': deviceParameter.minimum,
      'maximum': deviceParameter.maximum,
      'default_value': deviceParameter.defaultValue,
      'nr1': deviceParameter.nr1,
      'nr2': deviceParameter.nr2,
      'value_labels': deviceParameter.valueLabels
          .map((e) => DeviceDefinitionValueLabelSerializer.toMap(e))
          .toList(),
    };
  }
}

extension DeviceDefinitionValueLabelSerializer on DeviceDefinitionValueLabel {
  static Map<String, dynamic> toMap(DeviceDefinitionValueLabel deviceDefinitionValueLabel) {
    return {
      'value': deviceDefinitionValueLabel.value,
      'label': deviceDefinitionValueLabel.label,
    };
  }
}
