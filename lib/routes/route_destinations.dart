import 'package:favourite_place/routes/route_names.dart';
import 'package:favourite_place/view/place_screen.dart';
import 'package:get/get.dart';

class RouteDestinations {
  static List<GetPage> pages = [
    GetPage(
      name: RouteNames.placeScreen,
      page: () => const PlaceScreen(),
    ),
  ];
}
