# drift_orm_codegen

A code generation package for drift_orm annotations. This package reads `drift_orm` annotations and generates helpful extension methods.

## Features

- **@GenerateHelloWorld**: Generates greeting methods for annotated classes
- Customizable greeting names
- Automatic code generation using build_runner
- Clean, formatted output using dart_style

## Getting started

Add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  drift_orm: ^1.0.0

dev_dependencies:
  build_runner: ^2.4.7
  drift_orm_codegen: ^1.0.0
```

## Usage

1. Import the drift_orm package and add the part directive:

```dart
import 'package:drift_orm/drift_orm.dart';

part 'your_file.drift_orm.g.dart';
```

2. Annotate your classes with `@GenerateHelloWorld`:

```dart
@GenerateHelloWorld(name: 'Developer')
class MyService {
  void doSomething() {
    print('Doing something...');
  }
}

@GenerateHelloWorld() // Uses default 'World'
class AnotherService {
  // Your code here
}
```

3. Run code generation:

```bash
dart run build_runner build
```

4. Use the generated methods:

```dart
void main() {
  final service = MyService();
  service.printHello(); // Prints: Hello, Developer! Generated for MyService
  
  String greeting = service.sayHello(); // Returns greeting string
  print(greeting);
}
```

## Example

See the [example](example/drift_orm_codegen_example.dart) for a complete demonstration.

## Generated Methods

For each annotated class, the following extension methods are generated:

- `sayHello()`: Returns a greeting string
- `printHello()`: Prints the greeting to console

## Additional information

This package is part of the drift_orm ecosystem and demonstrates how to create custom code generators using Dart's build system.
