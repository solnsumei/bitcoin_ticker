import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = 'BD0013F9-6C40-404C-BC49-F985B85B5E5D';
const apiUrl = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future<dynamic> getCoinData({String coinName='BTC', String currency='USD'}) async {
    try {
      final http.Response response = await http.get('$apiUrl/$coinName/$currency', headers: {
        'X-CoinAPI-Key': apiKey,
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
  }
}
