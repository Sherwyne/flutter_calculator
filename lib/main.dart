import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'package:vibration/vibration.dart';


void main() {
  runApp(MaterialApp(
    home: MyCalculator(),
    debugShowCheckedModeBanner: false));
}

const List<String> calculator_items = [
  "C", "+/-", "%", "DEL", "7", "8", "9", "/", "4", "5", "6", "*", "1", "2", "3", "-", "0", ".", "=", "+"  
];

class CalculatorGrid extends StatefulWidget {
  CalculatorGrid({Key key}) : super(key: key);

  @override
  _CalculatorGridState createState() => _CalculatorGridState();
}

class _CalculatorGridState extends State<CalculatorGrid> {
  TextEditingController _controller;
  String _previousCalcuate = "";
  bool _toggleCalculate = false;

  @override
  void initState() {
    _controller = new TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  
  Color setBgColor(String item){
    switch(item){
      case "/":
        return Colors.grey[300];
      case "*":
        return Colors.grey[300];
      case "-":
        return Colors.grey[300];
      case "+":
        return Colors.grey[300];
      case "=":
        return Colors.amber;
      default:
        return Colors.white;
    }
  }

  void updateField(String item){
    setState(() {
      switch(item){
        case "C":
          _controller.text = "";
          _previousCalcuate = "";
          break;
        case "DEL":
          String oldValue = _controller.text;
          int oldLength = oldValue.length;
          if (oldLength <= 1){
            _controller.text = "";
          }
          else{
            _controller.text = oldValue.substring(0, oldLength-1);
          }
          break;
        case "=":
          Expression exp = Expression.parse(_controller.text);
          final evaluator = const ExpressionEvaluator();
          String r = evaluator.eval(exp, null).toString();
          _controller.text = r;
          _previousCalcuate = r;
          _toggleCalculate = true;
          break;
        default:
          if(_controller.text.isEmpty){
            try{
              int parsedItem = int.parse(item);
              _controller.text = parsedItem.toString();
            } catch (e) {
              _controller.text = "";
            }
          }
          else{
            _controller.text += item;
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                _previousCalcuate,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: _controller,
              readOnly: true,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 48,
                color: Colors.amber[600],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Wrap(
            children: calculator_items.map<Widget>((item) => FlatButton(
              onPressed: (){
                Vibration.vibrate(duration: 50);
                if(_toggleCalculate){
                  _controller.text = "";
                  _toggleCalculate = false;
                }
                updateField(item);
              },
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              color: setBgColor(item),
              child: Text(
                  "$item",
                  style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Impact",
                  color: Colors.black87,
                ),
              ),
            ),
          ).toList(),
        ),
      ),
    ]);
  }
}

class MyCalculator extends StatefulWidget {
  MyCalculator({Key key}) : super(key: key);

  @override
  _MyCalculatorState createState() => _MyCalculatorState();
}

class _MyCalculatorState extends State<MyCalculator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Calculator", style: TextStyle(
            fontSize: 24,
            fontFamily: "Impact",
            color: Colors.black87,
          ), 
        ),
        backgroundColor: Colors.amber[300],
      ),
      body: SafeArea(
        child: CalculatorGrid(),
      ),
    );
  }
}