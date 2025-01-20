import 'package:instrument_definition_converter/device_definition.dart';
import 'package:json_deserializer/json_deserializer.dart';

class DeviceDefinitionDeserializer extends JSONDeserializer<DeviceDefinition> {
  @override
  DeviceDefinition fromJSON(json) {
    return DeviceDefinition(
      id: json['id'] as String,
      name: json['name'] as String,
      abbr: json['abbr'] as String,
      manufacturer: json['manufacturer'] as String,
      parameters: ListDeserializer<DeviceParameter>(DeviceParameterDeserializer()).fromJSON(
        json['parameters'],
      ),
      script: json['script'] as String?,
    );
  }
}

class DeviceParameterDeserializer extends JSONDeserializer<DeviceParameter> {
  @override
  DeviceParameter fromJSON(json) {
    return DeviceParameter(
      type: DeviceParameterControlType.from(json['type'] as String),
      name: json['name'] as String,
      abbr: json['abbr'] as String,
      minimum: json['minimum'] as int,
      maximum: json['maximum'] as int,
      defaultValue: json['default_value'] as int,
      nr1: json['nr1'] as int?,
      nr2: json['nr2'] as int?,
      valueLabels: json['value_labels'] == null
          ? []
          : ListDeserializer(DeviceDefinitionValueLabelDeserializer()).fromJSON(
              json['value_labels'],
            ),
    );
  }
}

class DeviceDefinitionValueLabelDeserializer extends JSONDeserializer<DeviceDefinitionValueLabel> {
  @override
  DeviceDefinitionValueLabel fromJSON(json) {
    return DeviceDefinitionValueLabel(
      value: json['value'] as int,
      label: json['label'] as String,
    );
  }
}

class DeviceDefinitionSerializer {
  static Map<String, dynamic> toMap(DeviceDefinition deviceDefinition) {
    return {
      'id': deviceDefinition.id,
      'name': deviceDefinition.name,
      'abbr': deviceDefinition.abbr,
      'manufacturer': deviceDefinition.manufacturer,
      'parameters': deviceDefinition.parameters
          .map((e) => DeviceDefinitionParameterSerializer.toMap(e))
          .toList(),
      'script': deviceDefinition.script,
    };
  }
}

class DeviceDefinitionParameterSerializer {
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

class DeviceDefinitionValueLabelSerializer {
  static Map<String, dynamic> toMap(DeviceDefinitionValueLabel deviceDefinitionValueLabel) {
    return {
      'value': deviceDefinitionValueLabel.value,
      'label': deviceDefinitionValueLabel.label,
    };
  }
}
