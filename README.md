
# Device Definition Converter

Dart utility package to create OXI device definition files.

## Command-line Usage

### Install
Activate the Dart package globally on your computer:
`dart pub global activate --source git https://github.com/intonarumori/device_definition_converter.git`

### Convert
Run the command line executable:
`convert_midi_guide_instruments --input <path to midi_guide instruments folder> --output <path to output folder>`

For example:
`convert_midi_guide_instruments --input "midi" --output "output"`
Where input points to the root folder from `https://github.com/pencilresearch/midi`.

### Update

To update your local installation run `activate` again:
`dart pub global activate --source git https://github.com/intonarumori/device_definition_converter.git`

### Remove

To remove your local installation run `deactivate`:
`dart pub global deactivate device_definition_converter`

## Development

- Checkout the git source
- Run the default launch configuration using F5 in Visual Studio Code.