import 'currency_data.dart';

class DropdownData {
  final List<String> currencies = [];
  late String selectedValue = currencies.first;

  void convertItemsToString() {
    for (String currency in currenciesList.values.toList()) {
      currencies.add(currency.toString());
    }
  }
}
