import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'coin_data.dart';
import 'coin_data.dart';


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  final CoinData coinDataHelper = CoinData();
  String btcRate;
  String ethRate;
  String ltcRate;

  initState() {
    super.initState();
    getCoinData();
  }

  void getCoinData() async {
    var btcData, ltcData, ethData;

    try {
      await Future.wait<void>([
        (() async => btcData = await coinDataHelper.getCoinData(coinName: 'BTC', currency: selectedCurrency))(),
        (() async => ethData = await coinDataHelper.getCoinData(coinName: 'ETH', currency: selectedCurrency))(),
        (() async => ltcData = await coinDataHelper.getCoinData(coinName: 'LTC', currency: selectedCurrency))()
      ]);

      if (!mounted) return;
      if (btcData != null) {
        btcRate = '${(btcData['rate']).toInt()} $selectedCurrency';
      }

      if (ethData != null) {
        ethRate = '${(ethData['rate']).toInt()} $selectedCurrency';
      }

      if (ltcData != null) {
        ltcRate = '${(ltcData['rate']).toInt()} $selectedCurrency';
      }

      setState(() {});

    } catch (e) {
      print(e);
    }
  }

  List<dynamic> getMenuItems({isIOS = false}) {
    return currenciesList.map((item) {
      return isIOS
          ? Text(item, style: TextStyle(color: Colors.white),)
          : DropdownMenuItem<String>(value: item, child: Text(item),
      );
    }).toList();
  }

  Widget androidDropdown() {
    return DropdownButton<String>(
      value: selectedCurrency,
      onChanged: (value) {
        // print(value);
        setState(() {
          selectedCurrency = value;
        });

        getCoinData();
      },
      items: currenciesList.map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item),);
      }).toList(),
    );
  }

  Widget iOSPicker() {
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });

        getCoinData();
      },
      children: currenciesList.map((item) {
        return Text(item, style: TextStyle(color: Colors.white),);
      }).toList(),

    );
  }

  List<Widget> currencyCards() {

    return cryptoList.map((item) {
      final crytoRateMap = {
        'BTC': btcRate,
        'ETH': ethRate,
        'LTC': ltcRate,
      };

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
              '1 $item = ${crytoRateMap[item] ?? '? USD'}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ...currencyCards(),
          Spacer(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Theme.of(context).platform == TargetPlatform.iOS
                ? iOSPicker()
                : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
