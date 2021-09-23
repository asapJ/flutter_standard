<p align="center">
   <img title="Flutterwave" height="200" src="https://flutterwave.com/images/logo-colored.svg" width="50%"/>
</p>

# Flutterwave Flutter Standard SDK

## Table of Contents

- [About](#about)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Deployment](#deployment)
- [Built Using](#build-tools)
- [References](#references)
- [Support](#support)

<a id="about"></a>
## About
Flutterwave's Flutter SDK is Flutterwave's offical flutter sdk to integrate Flutterwave's [Standard](https://developer.flutterwave.com/docs/flutterwave-standard) payment into your flutter app. It comes with a ready made Drop In UI.



<a id="getting-started"></a>

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See [deployment](#deployment) for notes on how to deploy the project on a live system.
See [references](#references) for links to dashboard and API documentation.

### Prerequisite

- Ensure you have your test (and live) [API keys](https://developer.flutterwave.com/docs/api-keys).
```
Flutter version >= 1.17.0
Flutterwave version 3 API keys
```

 ### Installing

**Step 1.** Add the dependency

In your `pubspec.yaml` file add:

1. `flutterwave_standard: ^1.0.3`
2. run `flutter pub get`

<a id="usage"></a>
## Usage

### 1. Create a `Flutterwave` instance

Create a `Flutterwave` instance by calling the constructor `Flutterwave` The constructor accepts a mandatory instance of the following:
 the calling `Context` , `publicKey`, `Customer`, `amount`, `currency`, `email`, `fullName`, `txRef`, `isDebug`, `paymentOptions`, and `Customization` . It returns an instance of `Flutterwave`  which we then call the `async` method `.charge()` on.

      _handlePaymentInitialization() async {
        final style = FlutterwaveStyle(
            appBarText: "My Standard Blue",
            buttonColor: Color(0xffd0ebff),
            appBarIcon: Icon(Icons.message, color: Color(0xffd0ebff)),
            buttonTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          appBarColor: Color(0xffd0ebff),
          dialogCancelTextStyle: TextStyle(
            color: Colors.redAccent,
            fontSize: 18,
          ),
          dialogContinueTextStyle: TextStyle(
            color: Colors.blue,
            fontSize: 18,
          )
        );
        final Customer customer = Customer(
                name: "FLW Developer",
                phoneNumber: "1234566677777",
                email: "customer@customer.com");

        final Flutterwave flutterwave = Flutterwave(
            context: context,
            style: style,
            publicKey: "Public Key,
            currency: "RWF",
            txRef: "unique_transaction_reference",
            amount: "3000",
            customer: customer,
            paymentOptions: "ussd, card, barter, payattitude",
            customization: Customization(title: "Test Payment"),
            isDebug: true);
      }


### 2. Handle the response

 Calling the `.charge()` method returns a `Future`
 of `ChargeResponse` which we await for the actual response as seen above.
 
 ```
 final ChargeResponse response = await flutterwave.charge();
 if (response != null) {
   print(response.toJson());
   if(response.success) {
     Call the verify transaction endpoint with the transactionID returned in `response.transactionId` to verify transaction before offering value to customer
   } else {
    // Transaction not successful
   }
 } else {
   // User cancelled
 }
```



#### Please note that:
 - `ChargeResponse` can be null, depending on if the user cancels
   the transaction by pressing back.
 - You need to check the status of the transaction from the instance of `ChargeResponse` returned from calling `.charge()`, the `status`, `success` and `txRef` are successful and correct before providing value to the customer

>  **PLEASE NOTE**

> We advise you to do a further verification of transaction's details on your server to be sure everything checks out before providing service.
<a id="deployment"></a>
## Deployment

- Switch to Live Mode on the Dashboard settings page
- Use the Live Public API key from the API tab, see [here](https://developer.flutterwave.com/docs/api-keys) for more details.

<a id="build-tools"></a>
## Built Using
- [flutter](https://flutter.dev/)
- [http](https://pub.dev/packages/http)
- [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview)
- [fluttertoast](https://pub.dev/packages/fluttertoast)

<a id="references"></a>
## Flutterwave API  References

- [Flutterwave API Doc](https://developer.flutterwave.com/docs)
- [Flutterwave Inline Payment Doc](https://developer.flutterwave.com/docs/flutterwave-inline)
- [Flutterwave Dashboard](https://dashboard.flutterwave.com/login)

<a id="support"></a>
## Support
* Have issues integrating? Reach out via [our Developer forum](https://developer.flutterwave.com/discuss) for support

