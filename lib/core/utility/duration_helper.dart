String formatDuration(int totalSeconds) {
  final duration = Duration(seconds: totalSeconds);

  // Calculate hours, minutes, and seconds
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  // Format each component to two digits with leading zeros
  final hoursString = hours.toString().padLeft(2, '0');
  final minutesString = minutes.toString().padLeft(2, '0');
  final secondsString = seconds.toString().padLeft(2, '0');

  // Construct the final formatted string
  return '$hoursString hr:$minutesString min:$secondsString sec';
}
