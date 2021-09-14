import 'package:flutter/material.dart';
import 'package:flutterwave_standard/models/requests/standard_request.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:flutterwave_standard/core/navigation_controller.dart';
import 'package:flutterwave_standard/view/view_utils.dart';
import 'package:http/http.dart';

import 'flutterwave_style.dart';

class PaymentWidget extends StatefulWidget {
  final FlutterwaveStyle style;
  final StandardRequest request;

  BuildContext? loadingDialogContext;
  SnackBar? snackBar;

  PaymentWidget({required this.request, required this.style});

  @override
  State<StatefulWidget> createState() => _PaymentState();
}

class _PaymentState extends State<PaymentWidget> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  bool _isDisabled = false;
  late NavigationController controller;

  @override
  void initState() {
    _isDisabled = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller = NavigationController(context, Client(), widget.style);
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: widget.request.isTestMode,
      home: Scaffold(
        backgroundColor: widget.style.getMainBackgroundColor(),
        appBar: FlutterwaveViewUtils.appBar(
          context,
          widget.style.getAppBarText(),
          widget.style.getAppBarTextStyle(),
          widget.style.getAppBarIcon(),
          widget.style.getAppBarColor(),
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: ElevatedButton(
              autofocus: true,
              onPressed: _handleButtonClicked,
              style: ElevatedButton.styleFrom(
                  primary: widget.style.getButtonColor(),
                  textStyle: widget.style.getButtonTextStyle()),
              child: Text(
                widget.style.getButtonText(),
                style: widget.style.getButtonTextStyle(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleButtonClicked() {
    if (_isDisabled) return;
    _showConfirmDialog();
  }

  void _handlePayment() async {
    try {
      Navigator.of(context).pop(); // to remove confirmation dialog
      _toggleButtonActive(false);
      final response = await controller.startTransaction(widget.request);
      _toggleButtonActive(true);
      this._handlePaymentComplete(response);
    } catch (error) {
      _toggleButtonActive(true);
      _showError(error.toString());
    }
  }

  void _toggleButtonActive(final bool shouldEnable) {
    setState(() {
      _isDisabled = !shouldEnable;
    });
  }

  void _handlePaymentComplete(ChargeResponse response) {
    Navigator.pop(context, response); // return response to user
  }

  void _showError(final String errorMessage) {
    FlutterwaveViewUtils.showToast(context, errorMessage);
    Navigator.pop(context); // return response to user
  }

  void _showConfirmDialog() {
    FlutterwaveViewUtils.showConfirmPaymentModal(
        context,
        widget.request.currency,
        widget.request.amount,
        widget.style.getMainTextStyle(),
        widget.style.getDialogBackgroundColor(),
        widget.style.getDialogCancelTextStyle(),
        widget.style.getDialogContinueTextStyle(),
        _handlePayment);
  }
}
