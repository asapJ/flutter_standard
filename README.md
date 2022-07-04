
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

## Requirements
- Ensure you have your test (and live) [API keys](https://developer.flutterwave.com/docs/api-keys).   
  ``` Flutter version >= 1.17.0 Flutterwave version 3 API keys ```

## Installation Add the dependency

In your `pubspec.yaml` file add:

1. `flutterwave_standard: ^1.0.4`
2. run `flutter pub get`  
   <a id="usage"></a>

## Usage

Create a `Flutterwave` instance by calling the constructor `Flutterwave` The constructor accepts a mandatory instance of the following:  
the calling `Context` , `publicKey`, `Customer`, `amount`, `currency`, `email`, `fullName`, `txRef`, `isDebug`, `paymentOptions`, and `Customization` . It returns an instance of `Flutterwave` which we then call the `async` method `.charge()` on.

    _handlePaymentInitialization() async { 
    final style = FlutterwaveStyle(
     appBarText: "My Standard Blue", 
     buttonColor: Color(0xffd0ebff), 
     appBarIcon: Icon(Icons.message, color: Color(0xffd0ebff)),
     buttonTextStyle: TextStyle( 
	     color: Colors.black, 
	     fontWeight: FontWeight.bold, 
	     fontSize: 18), 
    appBarColor: Color(0xffd0ebff), 
    dialogCancelTextStyle: TextStyle(
	    color: Colors.redAccent, 
	    fontSize: 18
	    ),
    dialogContinueTextStyle: TextStyle(
		    color: Colors.blue, 
		    fontSize: 18
		    ) 
		  ); 

    final Customer customer = Customer(
		    name: "FLW Developer", 
		    phoneNumber: "1234566677777", 
		    email: "customer@customer.com"
		    );  
		    
    final Flutterwave flutterwave = Flutterwave(
		    context: context, 
		    style: style, 
		    publicKey: "Public Key, 
		    currency: "RWF", 
		    redirectUrl: "my_redirect_url" 
		    txRef: "unique_transaction_reference", 
		    amount: "3000", 
		    customer: customer, 
		    paymentOptions: "ussd, card, barter, payattitude", 
		    customization: Customization(title: "Test Payment"),
		    isDebug: true
		    ); 
		} 

### 2. Handle the response

Calling the `.charge()` method returns a `Future`  
of `ChargeResponse` which we await for the actual response as seen above.



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

#### Please note that:
- `ChargeResponse` can be null, depending on if the user cancels  
  the transaction by pressing back.
- You need to check the status of the transaction from the instance of `ChargeResponse` returned from calling `.charge()`, the `status`, `success` and `txRef` are successful and correct before providing value to the customer

>  **PLEASE NOTE**

> We advise you to do a further verification of transaction's details on your server to be sure everything checks out before providing service.  
<a id="deployment"></a>


##Testing
`pub run test`

## Debugging Errors
We understand that you may run into some errors while integrating our library. You can read more about our error messages [here](https://developer.flutterwave.com/docs/integration-guides/errors).

For `authorization` and `validation` error responses, double-check your API keys and request. If you get a `server` error, kindly engage the team for support.

<a id="support"></a>
## Support For additional assistance using this library, contact the developer experience (DX) team via [email](mailto:developers@flutterwavego.com) or on [slack](https://bit.ly/34Vkzcg).

You can also follow us [@FlutterwaveEng](https://twitter.com/FlutterwaveEng) and let us know what you think 😊

## Contribution guidelines
Read more about our community contribution guidelines [here](https://www.notion.so/flutterwavego/Community-contribution-guide-ca1d8a876ba04d45ab4b663c758ae42a).

## License
By contributing to the Flutter library, you agree that your contributions will be licensed under its [MIT license](https://opensource.org/licenses/MIT).

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