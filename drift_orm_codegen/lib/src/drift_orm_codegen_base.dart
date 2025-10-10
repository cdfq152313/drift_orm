import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:drift_orm/drift_orm.dart';
import 'package:source_gen/source_gen.dart';

/// Generator for GenerateHelloWorld annotation
class HelloWorldGenerator extends GeneratorForAnnotation<GenerateHelloWorld> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'GenerateHelloWorld can only be applied to classes.',
        element: element,
      );
    }

    final className = element.name;
    final name = annotation.read('name').stringValue;

    final template = """
extension ${className}HelloWorldExtension on $className {
  String sayHello() {
    return "Hello, $name! Generated for $className";
  }

  void printHello() {
    print(sayHello());
  }
}
""";

    final formatter =
        DartFormatter(languageVersion: DartFormatter.latestLanguageVersion);

    return formatter.format(template);
  }
}

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}
