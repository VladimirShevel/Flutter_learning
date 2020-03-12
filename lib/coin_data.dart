import 'helpers/network_helper.dart';

const url = 'https://rest.coinapi.io/v1/exchangerate/';

const headers = {'X-CoinAPI-Key': 'CC376FE0-6D73-49E3-872D-BCC960DA5F34'};

const List<String> currenciesList = [
//  'AUD',
//  'BRL',
//  'CAD',
//  'CNY',
  'EUR',
  'GBP',
//  'HKD',
//  'IDR',
//  'ILS',
//  'INR',
  'JPY',
//  'MXN',
//  'NOK',
//  'NZD',
//  'PLN',
//  'RON',
//  'RUB',
//  'SEK',
//  'SGD',
  'USD',
//  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<Map<String, String>> getRate(String currency) async {
    Map<String, String> coinRates = {};
    for (String crypto in cryptoList) {
      try {
        var data =
            await NetworkHelper(url: '$url$crypto/$currency', headers: headers)
                .getData();

        coinRates[crypto] = data['rate'].round().toString();
      } catch (e) {
        coinRates[crypto] = 'not Accesible';
      }
    }
    return coinRates;
  }
}
