String mapErrorToMessage(Object error) {
  final msg = error.toString();
  if (msg.contains('NetworkFailure')) {
    return 'Unable to connect. Please check your internet connection.';
  } else if (msg.contains('CacheFailure')) {
    return 'Could not load saved data. Please try again.';
  } else if (msg.contains('NotFoundFailure')) {
    return 'Requested data was not found.';
  } else if (msg.contains('ValidationFailure')) {
    return 'Some information is invalid. Please check your input.';
  } else if (msg.contains('Location services are disabled')) {
    return 'Location services are disabled. Please enable GPS in your device settings.';
  } else if (msg.contains('Location permission denied')) {
    return 'Location permission denied. Please allow location access to use this feature.';
  } else if (msg.contains('Location permission permanently denied')) {
    return 'Location permission permanently denied. Please enable it in app settings.';
  }
  return 'Something went wrong. Please try again.';
}