import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'stock_model.dart';
import 'stock_painter.dart';

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

class CandleSticksView extends StatefulWidget {
  final String symbol;
  final Size viewSize;

  CandleSticksView(this.symbol, this.viewSize);

  @override
  State<CandleSticksView> createState() {
    return _CandleStickViewState("stocks/00700/k_day.json");
  }

}

class _CandleStickViewState extends State<CandleSticksView> {
  String _dataPath;
  StockData _data;
  CandleSticksPainterConfig _painterConfig;

  double _virtualWidth;

  _CandleStickViewState(this._dataPath);

  void _onDataReady(StockData data) {
    setState(() {
      _data = data;
      _painterConfig = CandleSticksPainterConfig();
      _virtualWidth = (_painterConfig.candleWidth + _painterConfig.candleMargin * 2) * data.items.length;
    });
  }

  void _onDragUpdate(double offset) {
    debugPrint(offset.toString());
    setState(() {
      double newOffset = _painterConfig.viewOffset - offset;

      if (newOffset < 0) {
        newOffset = 0;
      }

      if (newOffset > _virtualWidth - widget.viewSize.width) {
        newOffset = _virtualWidth - widget.viewSize.width;
      }

      _painterConfig.viewOffset = newOffset;
    });
  }

  @override
  void initState() {
    StockData.loadFromBundle(rootBundle, _dataPath).then(
      (data) { _onDataReady(data); }
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null) {
      return ConstrainedBox (
        constraints: BoxConstraints.loose(
          Size(double.infinity, 500),
        ),
        child: CircularProgressIndicator(),
      );
    } else {
      return ConstrainedBox (
        constraints: BoxConstraints.loose(
          Size(double.infinity, 500),
        ),
        child: GestureDetector(
          child: CustomPaint(
            painter: CandleStickPainter(_data, _painterConfig),
            size: widget.viewSize,
          ),

          onHorizontalDragStart: (DragStartDetails details) => {
            debugPrint("Drag Start: {details}")
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) => {
            _onDragUpdate(details.primaryDelta)
          },
          onHorizontalDragEnd: (DragEndDetails details) => {
            debugPrint("Drag End: {details}")
          },
          onHorizontalDragCancel: () => {
            debugPrint("Drag Canceled")
          },
          onHorizontalDragDown: (DragDownDetails details) => {
            debugPrint("Drag Down: {details}")
          },
        ),
      );
    }
  }
}

