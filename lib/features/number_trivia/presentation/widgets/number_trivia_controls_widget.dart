import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia_app/features/number_trivia/presentation/provider/number_trivia_provider.dart';

class NumberTriviaControlsWidget extends StatefulWidget {
  const NumberTriviaControlsWidget({
    Key key,
  }) : super(key: key);

  @override
  _NumberTriviaControlsWidgetState createState() =>
      _NumberTriviaControlsWidgetState();
}

class _NumberTriviaControlsWidgetState
    extends State<NumberTriviaControlsWidget> {
  final controller = TextEditingController();
  final GlobalKey<FormFieldState> key = new GlobalKey();
  String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          key: key,
          controller: controller,
          validator: (value) {
            if (value.isEmpty) {
              return 'Cannot be empty';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => inputStr = value,
          onFieldSubmitted: (_) => dispatchConcrete,
        ),
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text('Search'),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: RaisedButton(
                child: Text('Get random trivia'),
                onPressed: dispatchRandom,
              ),
            )
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    final valid = key.currentState.validate();
    if (valid) {
      controller.clear();
      Provider.of<NumberTriviaProvider>(context, listen: false)
          .getTriviaForConcreteNumber(inputStr);
    }
  }

  void dispatchRandom() {
    controller.clear();
    Provider.of<NumberTriviaProvider>(context, listen: false)
        .getTriviaForRandomNumber();
  }
}
