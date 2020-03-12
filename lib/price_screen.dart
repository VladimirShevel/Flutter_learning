import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String currency = currenciesList[0];
  Map<String, String> coinValues = {};
  bool isWaiting = false;
  Future<void> getData() async {
    isWaiting = true;
    var rate = await CoinData().getRate(currency);
    setState(
      () {
        coinValues = rate;
      },
    );
    isWaiting = false;
  }

  DropdownButton<String> androidDropdown(List<String> items) {
    List<DropdownMenuItem<String>> widgets = [];
    for (String item in items) {
      widgets.add(
        DropdownMenuItem(
          value: item,
          child: Text(item),
        ),
      );
    }
    return DropdownButton<String>(
        items: widgets,
        value: currency,
        elevation: 16,
        style: TextStyle(
          fontSize: 40.0,
          color: Colors.white,
        ),
        onChanged: (String newValue) {
          setState(
            () {
              currency = newValue;
              getData();
            },
          );
        });
  }

  Widget iOSPicker(List<String> itemTexts) {
    List<Text> items = [];
    for (String itemText in itemTexts) {
      items.add(
        Text(
          itemText,
          style: TextStyle(fontSize: 40.0, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }
    return CupertinoPicker(
        useMagnifier: true,
        itemExtent: 60.0,
        backgroundColor: Colors.lightBlue,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            currency = currenciesList[selectedIndex];
            getData();
          });
        },
        children: items);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<CoinCard> coinCardsColumn(
      Map<String, String> coinsRate, String currency) {
    List<CoinCard> column = [];
    coinsRate.forEach(
      (k, v) {
        column.add(
          CoinCard(
              currency: currency,
              rate: isWaiting ? 'wait' : v,
              cryptoCurrency: isWaiting ? 'coin' : k),
        );
      },
    );
    return column;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: coinCardsColumn(coinValues, currency),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            //padding: EdgeInsets.only(top: 20.0),
            color: Colors.lightBlue,
            child: Center(
              child: Platform.isIOS
                  ? iOSPicker(currenciesList)
                  : androidDropdown(currenciesList),
            ),
          ),
        ],
      ),
    );
  }
}

class CoinCard extends StatelessWidget {
  const CoinCard(
      {@required this.currency,
      @required this.rate,
      @required this.cryptoCurrency});

  final String currency;
  final String rate;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $rate $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
