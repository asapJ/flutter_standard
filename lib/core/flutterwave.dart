import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterwave_standard/core/TransactionCallBack.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/requests/standard_request.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:flutterwave_standard/models/subaccount.dart';
import 'package:flutterwave_standard/utils.dart';
import 'package:flutterwave_standard/view/flutterwave_style.dart';
import 'package:flutterwave_standard/view/payment_widget.dart';
import 'package:flutterwave_standard/view/view_utils.dart';

class Flutterwave {
  BuildContext context;
  String txRef;
  String amount;
  Customization customization;
  Customer customer;
  bool isTestMode;
  String publicKey;
  ///Defaults to "card, ussd"
  ///You can other options and separate them with comma
  String paymentOptions;
  String? currency;
  String? paymentPlanId;
  String? redirectUrl;
  List<SubAccount>? subAccounts;
  Map<dynamic, dynamic>? meta;
  FlutterwaveStyle? style;

  Flutterwave(
      {required this.context,
      required this.publicKey,
      required this.txRef,
      required this.amount,
      required this.customer,
      this.paymentOptions = "card, ussd",
      required this.customization,
      required this.isTestMode,
      this.currency,
      this.paymentPlanId,
      this.redirectUrl,
      this.subAccounts,
      this.meta,
      this.style});

  /// Starts Standard Transaction
  Future<ChargeResponse> charge() async {
    final request = StandardRequest(
        txRef: txRef,
        amount: amount,
        customer: customer,
        paymentOptions: paymentOptions,
        customization: customization,
        isTestMode: isTestMode,
        publicKey: publicKey,
        currency: currency,
        paymentPlanId: paymentPlanId,
        redirectUrl: redirectUrl ?? Utils.DEFAULT_URL,
        subAccounts: subAccounts,
        meta: meta);

    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentWidget(
          request: request,
          style: style ?? FlutterwaveStyle(),
        ),
      ),
    );
  }
}

class TransactionCallbackImpl implements TransactionCallBack {
  final BuildContext context;
  TransactionCallbackImpl(this.context);

  void _showErrorAndClose(final String errorMessage) {
    FlutterwaveViewUtils.showToast(context, errorMessage);
    Navigator.pop(context); // return response to user
  }

  @override
  onTransactionError() {
    _showErrorAndClose("transaction error");
  }

  @override
  onCancelled() {
    FlutterwaveViewUtils.showToast(context, "Transaction Cancelled");
    Navigator.pop(context);
  }

  @override
  onTransactionSuccess(String id, String txRef) {
    final ChargeResponse chargeResponse = ChargeResponse(
        status: "success", success: true, transactionId: id, txRef: txRef);
    Navigator.pop(this.context, chargeResponse);
  }
}
