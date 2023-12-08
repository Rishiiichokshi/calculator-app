import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../screen/currency_converter/conversion_card.dart';

class ConversionController extends GetxController {
  // List to store the added containers
  final RxList<ConversionData> conversionDataList = <ConversionData>[].obs;
}
