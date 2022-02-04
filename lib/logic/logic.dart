class RegExpClass {
  final validEmail = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
  final validPass = RegExp(r'^.{8,}$');
}
