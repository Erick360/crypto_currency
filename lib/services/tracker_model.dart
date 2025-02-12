import 'package:bitcoin_tracker/coin_data.dart';
import 'package:flutter/foundation.dart';
import 'network.dart';

const apiKey = "your api here";
const coinApiUrl = "https://api-realtime.exrates.coinapi.io/v1/exchangerate";

class TrackerModel {
  Future<dynamic> getCurrency(String currency) async {
    Map<String, String> cryptoPrices = {};
    try {
      for (String crypto in cryptoList) {
        String url = '$coinApiUrl/$crypto/$currency?apikey=$apiKey';
        Networking networking = Networking(url);
        var request = await networking.getData();
        if (request != null && request.containsKey('rate')) {
          double price = request['rate'];
          cryptoPrices[crypto] = price.toStringAsFixed(0);
        } else {
          if (kDebugMode) {
            print('Error: Missing "rate" in response for $crypto/$currency');
          }
          cryptoPrices[crypto] = 'N/A';
        }
      }
    }catch(e){
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
      for (String crypto in cryptoList) {
        cryptoPrices[crypto] = 'N/A';
      }
    }
    return cryptoPrices;
  }
}
