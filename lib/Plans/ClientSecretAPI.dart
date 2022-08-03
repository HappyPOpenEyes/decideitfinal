// To parse this JSON data, do
//
//     final clientSecretApi = clientSecretApiFromJson(jsonString);

import 'dart:convert';

ClientSecretApi clientSecretApiFromJson(String str) =>
    ClientSecretApi.fromJson(json.decode(str));

String clientSecretApiToJson(ClientSecretApi data) =>
    json.encode(data.toJson());

class ClientSecretApi {
  ClientSecretApi({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  Data data;

  factory ClientSecretApi.fromJson(Map<String, dynamic> json) =>
      ClientSecretApi(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.object,
    this.application,
    this.cancellationReason,
    required this.clientSecret,
    required this.created,
    this.customer,
    this.description,
    this.lastSetupError,
    this.latestAttempt,
    required this.livemode,
    this.mandate,
    required this.metadata,
    this.nextAction,
    this.onBehalfOf,
    this.paymentMethod,
    required this.paymentMethodOptions,
    required this.paymentMethodTypes,
    this.singleUseMandate,
    required this.status,
    required this.usage,
  });

  String id;
  String object;
  dynamic application;
  dynamic cancellationReason;
  String clientSecret;
  int created;
  dynamic customer;
  dynamic description;
  dynamic lastSetupError;
  dynamic latestAttempt;
  bool livemode;
  dynamic mandate;
  List<dynamic> metadata;
  dynamic nextAction;
  dynamic onBehalfOf;
  dynamic paymentMethod;
  PaymentMethodOptions paymentMethodOptions;
  List<String> paymentMethodTypes;
  dynamic singleUseMandate;
  String status;
  String usage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        object: json["object"],
        application: json["application"],
        cancellationReason: json["cancellation_reason"],
        clientSecret: json["client_secret"],
        created: json["created"],
        customer: json["customer"],
        description: json["description"],
        lastSetupError: json["last_setup_error"],
        latestAttempt: json["latest_attempt"],
        livemode: json["livemode"],
        mandate: json["mandate"],
        metadata: List<dynamic>.from(json["metadata"].map((x) => x)),
        nextAction: json["next_action"],
        onBehalfOf: json["on_behalf_of"],
        paymentMethod: json["payment_method"],
        paymentMethodOptions:
            PaymentMethodOptions.fromJson(json["payment_method_options"]),
        paymentMethodTypes:
            List<String>.from(json["payment_method_types"].map((x) => x)),
        singleUseMandate: json["single_use_mandate"],
        status: json["status"],
        usage: json["usage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "application": application,
        "cancellation_reason": cancellationReason,
        "client_secret": clientSecret,
        "created": created,
        "customer": customer,
        "description": description,
        "last_setup_error": lastSetupError,
        "latest_attempt": latestAttempt,
        "livemode": livemode,
        "mandate": mandate,
        "metadata": List<dynamic>.from(metadata.map((x) => x)),
        "next_action": nextAction,
        "on_behalf_of": onBehalfOf,
        "payment_method": paymentMethod,
        "payment_method_options": paymentMethodOptions.toJson(),
        "payment_method_types":
            List<dynamic>.from(paymentMethodTypes.map((x) => x)),
        "single_use_mandate": singleUseMandate,
        "status": status,
        "usage": usage,
      };
}

class PaymentMethodOptions {
  PaymentMethodOptions({
    this.card,
  });

  var card;

  factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) =>
      PaymentMethodOptions(
        card: json["card"],
      );

  Map<String, dynamic> toJson() => {
        "card": card.toJson(),
      };
}
