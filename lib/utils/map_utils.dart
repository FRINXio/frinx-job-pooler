import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  static const GOOGLE_MAPS_URI =
      'https://www.google.com/maps/search/?api=1&query';

  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    var googleUrl = '$GOOGLE_MAPS_URI$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      // todo: error handling in application
      throw 'Could not open the map.';
    }
  }
}
