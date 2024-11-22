import 'package:get/get.dart';
import 'package:mongo/Screens/counter_model.dart';
// part 'app_routes.dart';

class AppPages {
  static final pages = [
  GetPage(
      name: '/counterScreen',
      // name: Routes.tabBarScreen,
      page: () => const CounterPage(),
      transition: Transition.noTransition,
      // transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
