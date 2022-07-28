import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/TransactionCallBack.dart';
import 'package:flutterwave_standard/models/requests/standard_request.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:flutterwave_standard/core/navigation_controller.dart';
import 'package:flutterwave_standard/view/view_utils.dart';
import 'package:http/http.dart';

import 'flutterwave_style.dart';

class PaymentWidget extends StatefulWidget {
  final FlutterwaveStyle style;
  final StandardRequest request;
  final BuildContext mainContext;

  PaymentWidget(
      {required this.request, required this.style, required this.mainContext});

  @override
  State<StatefulWidget> createState() => _PaymentState();
}

class _PaymentState extends State<PaymentWidget>
    implements TransactionCallBack {
  late NavigationController controller;

  @override
  void initState() {
    super.initState();
    _handlePayment();
  }

  @override
  Widget build(BuildContext context) {
    controller = NavigationController(Client(), widget.style, this);
    return Scaffold(body: SizedBox());
  }

  void _handlePayment() async {
    await Future.delayed(Duration(milliseconds: 200));
    try {
      controller.startTransaction(widget.request);
    } catch (error) {
      _showErrorAndClose(error.toString());
    }
  }

  void _showErrorAndClose(final String errorMessage) {
    // FlutterwaveViewUtils.showToast(widget.mainContext, errorMessage);
    Navigator.pop(widget.mainContext); // return response to user
  }

  @override
  onTransactionError() {
    _showErrorAndClose("transaction error");
  }

  @override
  onCancelled() {
    FlutterwaveViewUtils.showToast(widget.mainContext, "Transaction Cancelled");
    Navigator.pop(widget.mainContext);
  }

  @override
  onTransactionSuccess(String id, String txRef) async {
    final ChargeResponse chargeResponse = ChargeResponse(
        status: "success", success: true, transactionId: id, txRef: txRef);
    await Future.delayed(Duration(milliseconds: 400));
    Navigator.pop(this.widget.mainContext, chargeResponse);
  }
}
