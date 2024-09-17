String formatDuration(int totalSeconds) {
  final duration = Duration(seconds: totalSeconds);

  // Calculate hours and minutes with fraction
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  // Initialize the final string
  String formattedTime = '';

  // Conditionally add hours and fractional minutes to the final string
  if (hours > 0) {
    formattedTime += '$hours hours';
  }

  // Calculate fractional minutes
  final fractionalMinutes = minutes + (seconds / 60);

  if (fractionalMinutes > 0 || hours == 0) {
    if (formattedTime.isNotEmpty) {
      formattedTime += ': ';
    }
    // Round to 1 decimal place for fractional minutes
    formattedTime += '${fractionalMinutes.toStringAsFixed(1)} minutes';
  }

  // Handle edge case where both hours and minutes are zero
  if (formattedTime.isEmpty) {
    formattedTime = '0 minutes';
  }

  print(formattedTime);
  return formattedTime;
}
