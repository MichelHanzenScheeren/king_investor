extension StringExtension on String {
  String firstToUpper() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
