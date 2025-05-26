import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxString username = 'Nguyen Dinh Trong'.obs;
  final RxInt posts = 100.obs;
  final RxInt followers = 1000.obs;
  final RxInt following = 100.obs;

  void follow() {
    followers.value += 1;
  }
}