import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterwave_standard/core/transaction_status.dart';
import 'package:flutterwave_standard/view/flutterwave_style.dart';
import 'package:flutterwave_standard/view/webview.dart';
import 'package:http/http.dart';

import '../models/TransactionError.dart';
import '../models/requests/standard_request.dart';
import '../models/responses/charge_response.dart';
import '../models/responses/standard_response.dart';

class NavigationController {
  BuildContext _buildContext;
  Client client;
  final FlutterwaveStyle? style;

  NavigationController(this._buildContext, this.client, this.style);


  /// Initiates initial transaction to get web url
  Future<ChargeResponse> startTransaction(final StandardRequest request) async {
    try {
      final StandardResponse standardResponse =
          await request.execute(this.client);
      if (standardResponse.status == "error") {
        throw (TransactionError(standardResponse.message!));
      }
      final Map response = await openBrowser(
          standardResponse.data?.link ?? "", request.redirectUrl);
      return _handleResponse(response);
    } catch (error) {
      throw (error);
    }
  }


  ChargeResponse _handleResponse(response) {
    final status = response["status"];
    if (TransactionStatus.CANCELLED.toString() == status) {
      throw (TransactionError("Transaction cancelled"));
    }
    return ChargeResponse.fromJson(response);
  }


  /// Opens browser with URL returned from startTransaction()
  Future<Map<String, dynamic>> openBrowser(
      final String url,
      final String redirectUrl
      ) async {
    var response = await Navigator.push(
      _buildContext,
      MaterialPageRoute(
          builder: (context) => FlutterwaveWebview(url, redirectUrl)),
    );
    if (response == null) {
      Map<String, dynamic> errorResponse = {
        "status": TransactionStatus.CANCELLED
      };
      return errorResponse;
    }
    return response;
  }
}
