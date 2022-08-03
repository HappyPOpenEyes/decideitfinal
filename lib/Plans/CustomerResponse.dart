// To parse this JSON data, do
//
//     final customerResponse = customerResponseFromJson(jsonString);

import 'dart:convert';

CustomerResponse customerResponseFromJson(String str) => CustomerResponse.fromJson(json.decode(str));

String customerResponseToJson(CustomerResponse data) => json.encode(data.toJson());

class CustomerResponse {
    CustomerResponse({
        required this.id,
        required this.object,
        this.address,
        required this.balance,
        required this.created,
        this.currency,
        this.defaultSource,
        required this.delinquent,
        required this.description,
        this.discount,
        required this.email,
        required this.invoicePrefix,
        required this.invoiceSettings,
        required this.livemode,
        required this.metadata,
        required this.name,
        required this.nextInvoiceSequence,
        this.phone,
        required this.preferredLocales,
        this.shipping,
        required this.taxExempt,
    });

    String id;
    String object;
    dynamic address;
    int balance;
    int created;
    dynamic currency;
    dynamic defaultSource;
    bool delinquent;
    String description;
    dynamic discount;
    String email;
    String invoicePrefix;
    InvoiceSettings invoiceSettings;
    bool livemode;
    Metadata metadata;
    String name;
    int nextInvoiceSequence;
    dynamic phone;
    List<dynamic> preferredLocales;
    dynamic shipping;
    String taxExempt;

    factory CustomerResponse.fromJson(Map<String, dynamic> json) => CustomerResponse(
        id: json["id"],
        object: json["object"],
        address: json["address"],
        balance: json["balance"],
        created: json["created"],
        currency: json["currency"],
        defaultSource: json["default_source"],
        delinquent: json["delinquent"],
        description: json["description"],
        discount: json["discount"],
        email: json["email"],
        invoicePrefix: json["invoice_prefix"],
        invoiceSettings: InvoiceSettings.fromJson(json["invoice_settings"]),
        livemode: json["livemode"],
        metadata: Metadata.fromJson(json["metadata"]),
        name: json["name"],
        nextInvoiceSequence: json["next_invoice_sequence"],
        phone: json["phone"],
        preferredLocales: List<dynamic>.from(json["preferred_locales"].map((x) => x)),
        shipping: json["shipping"],
        taxExempt: json["tax_exempt"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "address": address,
        "balance": balance,
        "created": created,
        "currency": currency,
        "default_source": defaultSource,
        "delinquent": delinquent,
        "description": description,
        "discount": discount,
        "email": email,
        "invoice_prefix": invoicePrefix,
        "invoice_settings": invoiceSettings.toJson(),
        "livemode": livemode,
        "metadata": metadata.toJson(),
        "name": name,
        "next_invoice_sequence": nextInvoiceSequence,
        "phone": phone,
        "preferred_locales": List<dynamic>.from(preferredLocales.map((x) => x)),
        "shipping": shipping,
        "tax_exempt": taxExempt,
    };
}

class InvoiceSettings {
    InvoiceSettings({
        this.customFields,
        this.defaultPaymentMethod,
        this.footer,
    });

    dynamic customFields;
    dynamic defaultPaymentMethod;
    dynamic footer;

    factory InvoiceSettings.fromJson(Map<String, dynamic> json) => InvoiceSettings(
        customFields: json["custom_fields"],
        defaultPaymentMethod: json["default_payment_method"],
        footer: json["footer"],
    );

    Map<String, dynamic> toJson() => {
        "custom_fields": customFields,
        "default_payment_method": defaultPaymentMethod,
        "footer": footer,
    };
}

class Metadata {
    Metadata();

    factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    );

    Map<String, dynamic> toJson() => {
    };
}
