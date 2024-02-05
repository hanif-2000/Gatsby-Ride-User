String convertToFixedTwoDecimal(dynamic dynamicValue) {
  // Convert dynamic data to double
  double doubleValue = dynamicValue is double
      ? dynamicValue
      : double.tryParse('$dynamicValue') ?? 0.0;

  // Convert double to string with fixed decimal places
  String stringValue = doubleValue.toStringAsFixed(2);

  return stringValue;
}

String convertToFixedOneDecimal(dynamic dynamicValue) {
  // Convert dynamic data to double
  double doubleValue = dynamicValue is double
      ? dynamicValue
      : double.tryParse('$dynamicValue') ?? 0.0;

  // Convert double to string with fixed decimal places
  String stringValue = doubleValue.toStringAsFixed(1);

  return stringValue;
}
