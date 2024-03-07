import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forex/constants.dart';
import 'package:forex/widgets/error_bar_notifier.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../colors.dart';
import '../data models/currency_data.dart';
import '../data models/dropdown_button_data.dart';
import '../widgets/dropdown_options_button.dart';
import '../widgets/number_input_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const id = "/home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _numberFieldOne = TextEditingController();
  final TextEditingController _numberFieldTwo = TextEditingController();

  final DropdownData _firstButtonDropdownData = DropdownData();
  final DropdownData _secondButtonDropdownData = DropdownData();

  double selectedCurrencyRate = 0.0;
  bool showSpinner = false;
  bool _ignoringState = false;
  final String _invalidCurrency = "AAA";
  bool isTextFieldErrorMessagePresent = false;
  String? textFieldErrorMessage;
  bool? _firstButtonIsValid;
  bool? _secondButtonIsValid;

  InternetStatus? _connectionStatus;
  late StreamSubscription<InternetStatus> _connectivitySubscription;

  void _onFirstButtonSelectedValueChanged(String? newValue) {
    setState(() {
      _firstButtonDropdownData.selectedValue = newValue!;
      if (_firstButtonDropdownData.selectedValue == "") {
        _firstButtonIsValid = false;
      } else {
        _firstButtonIsValid = true;
      }
      if (_secondButtonDropdownData.selectedValue == newValue) {
        _secondButtonDropdownData.selectedValue =
            _secondButtonDropdownData.currencies.first;
        _secondButtonIsValid = false;
      }
    });
  }

  void _onSecondButtonSelectedValueChanged(String? newValue) {
    setState(() {
      _secondButtonDropdownData.selectedValue = newValue!;
      if (_secondButtonDropdownData.selectedValue == "") {
        _secondButtonIsValid = false;
      } else {
        _secondButtonIsValid = true;
      }
      if (_firstButtonDropdownData.selectedValue == newValue) {
        _firstButtonDropdownData.selectedValue =
            _firstButtonDropdownData.currencies.first;
        _firstButtonIsValid = false;
      }
    });
  }

  bool buttonValidator(String buttonCurrencyKey) {
    if (buttonCurrencyKey == _invalidCurrency) {
      return false;
    }
    return true;
  }

  void setNumberFieldTwoValue(String selectedCurrencyRate) {
    setState(() {
      _numberFieldTwo.text = selectedCurrencyRate;
    });
  }

  String checkNumberToDecideDecimalPlaces(double selectedCurrencyRate) {
    if (selectedCurrencyRate >= 0.005) {
      return selectedCurrencyRate.toStringAsFixed(2);
    } else {
      return selectedCurrencyRate.toString();
    }
  }

  void setAppInternetConnectionState() {
    if (_connectionStatus == InternetStatus.connected) {
      setState(() {
        _ignoringState = false;
      });
    } else if (_connectionStatus == InternetStatus.disconnected) {
      setState(() {
        _ignoringState = true;
      });
    }
  }

  dynamic getErrorMessage(bool? errorChecker) {
    if (errorChecker == false) {
      return "Invalid Currency selected";
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    _firstButtonDropdownData.convertItemsToString();
    _secondButtonDropdownData.convertItemsToString();
    _connectivitySubscription =
        InternetConnection().onStatusChange.listen((status) {
      setState(() {
        _connectionStatus = status;
        setAppInternetConnectionState();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _numberFieldTwo.dispose();
    _numberFieldOne.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.red.shade800,
          title: const Text("FOREX", style: TextStyle(fontSize: 25)),
        ),
        body: SafeArea(
          child: IgnorePointer(
            ignoring: _ignoringState,
            child: Stack(
              children: [
                if (_ignoringState) ...{
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(0.33),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ErrorNotification(errorText: "no internet connection"),
                      ],
                    ),
                  ),
                },
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NumberField(
                          enabled: true,
                          textEditingController: _numberFieldOne,
                          hintText: "Enter amount Here",
                          errorText: isTextFieldErrorMessagePresent
                              ? textFieldErrorMessage
                              : null,
                        ),
                        const SizedBox(height: 25),
                        NumberField(
                          enabled: false,
                          textEditingController: _numberFieldTwo,
                        ),
                        const SizedBox(height: 50),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "From",
                            style: kTextStyle.copyWith(color: Colors.redAccent),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropDownOptionsButton(
                          onChanged: _onFirstButtonSelectedValueChanged,
                          textAlignment: Alignment.centerRight,
                          value: _firstButtonDropdownData.selectedValue,
                          errorText: getErrorMessage(_firstButtonIsValid),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "To",
                            style: kTextStyle.copyWith(
                              color: Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropDownOptionsButton(
                          onChanged: _onSecondButtonSelectedValueChanged,
                          textAlignment: Alignment.centerLeft,
                          value: _secondButtonDropdownData.selectedValue,
                          errorText: getErrorMessage(_secondButtonIsValid),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            String fieldOneData = _numberFieldOne.text.trim();

                            if (fieldOneData.isNotEmpty &&
                                fieldOneData != "0") {
                              setState(() {
                                textFieldErrorMessage = null;
                                isTextFieldErrorMessagePresent = false;
                              });
                            } else {
                              setState(() {
                                textFieldErrorMessage =
                                    "Invalid amount entered";
                                isTextFieldErrorMessagePresent = true;
                              });
                            }

                            // Perform conversion operation.
                            if (_firstButtonIsValid == true &&
                                _secondButtonIsValid == true &&
                                isTextFieldErrorMessagePresent == false) {
                              setState(() {
                                showSpinner = true;
                              });

                              // Get Currency keys
                              String firstFieldCurrencyKey = currenciesList.keys
                                  .where((element) =>
                                      currenciesList[element] ==
                                      _firstButtonDropdownData.selectedValue)
                                  .toString();

                              String secondFieldCurrencyKey = currenciesList
                                  .keys
                                  .where((element) =>
                                      currenciesList[element] ==
                                      _secondButtonDropdownData.selectedValue)
                                  .toString();

                              // Remove () from currency keys
                              firstFieldCurrencyKey = firstFieldCurrencyKey
                                  .replaceAll(RegExp(r"[()]"), "");
                              secondFieldCurrencyKey = secondFieldCurrencyKey
                                  .replaceAll(RegExp(r"[()]"), "");

                              selectedCurrencyRate =
                                  await CurrencyData().getCurrencyData(
                                baseCurrency: firstFieldCurrencyKey,
                                targetCurrency: secondFieldCurrencyKey,
                                amount: double.parse(fieldOneData),
                              );

                              final String finalResult =
                                  checkNumberToDecideDecimalPlaces(
                                      selectedCurrencyRate);
                              setNumberFieldTwoValue(finalResult);
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          },
                          style: kButtonStyle,
                          child: const Text("Convert"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
