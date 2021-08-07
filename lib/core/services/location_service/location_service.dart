import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as loc;

import 'base_location_service.dart';

class LocationService implements BaseLocationService {

  LocationService({
    loc.Location? location,
    geocoding.GeocodingPlatform? geocodingPlatform,
  }) :  _location = location ?? loc.Location(),
        _geocodingPlatform = geocodingPlatform ?? geocoding.GeocodingPlatform.instance;

  final loc.Location _location;
  final geocoding.GeocodingPlatform _geocodingPlatform;

  @override
  Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    final placemarks = await _geocodingPlatform.placemarkFromCoordinates(latitude, longitude);
    return 
      '${placemarks.first.street ?? '-'}, ' // nama jalan
      '${placemarks.first.subLocality ?? '-'}, ' // kelurahan
      '${placemarks.first.locality ?? '-'}, ' // kecamatan
      '${placemarks.first.subAdministrativeArea ?? '-'}, ' // kota
      '${placemarks.first.administrativeArea ?? '-'} ' // provinsi
      '${placemarks.first.postalCode ?? '00000'}'; // kode pos
  }

  @override
  Future<List<double?>> getCurrentCoordinates() async {
    final getCoordinates = await _location.getLocation().timeout(const Duration(seconds: 5));
    return [getCoordinates.latitude, getCoordinates.longitude];
  }

  @override
  Future<bool> requestLocationPermission() async {
    final permStatus = await _location.requestPermission();
    if (permStatus == loc.PermissionStatus.granted || permStatus == loc.PermissionStatus.grantedLimited) {
      return true;
    }
    return _location.requestService().timeout(const Duration(seconds: 5));
  }
}
