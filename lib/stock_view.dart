import 'package:flutter/material.dart';
import 'candlestick_view.dart';

class StockViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock View"),
      ),
      body: Column(
        children: <Widget>[
          CandleSticksView("00700", Size(500, 300)),
        ],
      ),
    );
  }

}

