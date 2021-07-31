abstract class BaseLocationService {
  /// request for location permission,
  /// this will also prompt user to enable
  /// location service
  Future<bool> requestLocationPermission();

  /// returns:
  /// * latitude -> index 0
  /// * longitude -> index 1
  /// or throws TimeoutException or PlatformException
  Future<List<double?>> getCurrentCoordinates();

  /// gets address from given latitude and longitude
  /// can return dashes if the placemarks are unknown
  Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  });
}
