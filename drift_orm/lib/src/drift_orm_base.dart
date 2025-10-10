// TODO: Put public facing types in this file.

/// Annotation to mark classes that should generate hello world code
class GenerateHelloWorld {
  const GenerateHelloWorld({this.name = 'World'});
  
  /// The name to use in the greeting
  final String name;
}

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}
