class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({required this.message, required  this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com//v1';
  static String secret = '';

  static init() {}

  static StripeTransactionResponse payWithNewCard(String amount) {
    return new StripeTransactionResponse(message: 'Transaction Successful',success: true);
  }
}
