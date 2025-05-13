import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymobManager {
  Future<String> getPaymentKey(double amount) async {
    String currency = "EGP";
    try {
      String authanticationToken = await _getAuthanticationToken();

      int orderId = await _getOrderId(
        authanticationToken: authanticationToken,
        amount: (100 * amount).toString(),
        currency: currency,
      );

      await createOrderSupaBase(
        amountCents: (100 * amount),
        paymobOrderId: orderId,
      );

      String paymentKey = await _getPaymentKey(
        authanticationToken: authanticationToken,
        amount: (100 * amount).toString(),
        currency: currency,
        orderId: orderId.toString(),
      );
      return paymentKey;
    } catch (e) {
      throw Exception("Failed to get payment key: ${e}");
    }
  }

  Future<String> _getAuthanticationToken() async {
    final Response response = await Dio().post(
      "https://accept.paymob.com/api/auth/tokens",
      data: {"api_key": dotenv.env['PayMob_apiKey']!},
    );
    return response.data["token"];
  }

  Future<int> _getOrderId({
    required String authanticationToken,
    required String amount,
    required String currency,
  }) async {
    final Response response = await Dio().post(
      "https://accept.paymob.com/api/ecommerce/orders",
      data: {
        "auth_token": authanticationToken,
        "amount_cents": amount,
        "currency": currency,
        "delivery_needed": "false",
        "items": [],
      },
    );
    return response.data["id"]; //INTGER
  }

  Future<void> createOrderSupaBase({
    required int paymobOrderId,
    required double amountCents,
  }) async {
    final supabase = Supabase.instance.client;

    final user = supabase.auth.currentUser;
    try {
      await supabase.from('orders').insert({
        'order_id': paymobOrderId,
        'user_id': user!.id,
        'amount_cents': amountCents,
        'status': 'pending',
      });
    } catch (e) {
      throw Exception("Failed to create order: ${e}");
    }
  }

  Future<String> _getPaymentKey({
    required String authanticationToken,
    required String orderId,
    required String amount,
    required String currency,
  }) async {
    final Response response = await Dio().post(
      "https://accept.paymob.com/api/acceptance/payment_keys",
      data: {
        "expiration": 3600,

        "auth_token": authanticationToken,
        "order_id": orderId,
        "integration_id": dotenv.env['PayMob_integrationId_CARD']!,

        "amount_cents": amount,
        "currency": currency,

        "billing_data": {
          "first_name": "Clifford",
          "last_name": "Nicolas",
          "email": "claudette09@exa.com",
          "phone_number": "+86(8)9135210487",

          "apartment": "NA",
          "floor": "NA",
          "street": "NA",
          "building": "NA",
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "NA",
          "state": "NA",
        },
      },
    );
    return response.data["token"];
  }
}
