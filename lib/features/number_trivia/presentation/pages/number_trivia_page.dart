import 'package:flutter/material.dart';
import 'package:trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_app/features/number_trivia/presentation/pages/base_page.dart';
import 'package:trivia_app/features/number_trivia/presentation/provider/base_provider.dart';
import 'package:trivia_app/features/number_trivia/presentation/provider/number_trivia_provider.dart';
import 'package:trivia_app/features/number_trivia/presentation/widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  buildBody(BuildContext context) {
    return BasePage<NumberTriviaProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              SizedBox(height: 8),
              _buildDisplayWidget(provider),
              SizedBox(height: 16),
              NumberTriviaControlsWidget()
            ],
          ),
        );
      },
    );
  }

  _buildDisplayWidget(NumberTriviaProvider provider) {
    if (provider.state is Empty) {
      return MessageDisplay(message: 'Start searching!');
    } else if (provider.state is Loading) {
      return LoadingWidget();
    } else if (provider.state is Loaded) {
      final Loaded loaded = provider.state as Loaded;
      return NumberTriviaDisplay(numberTrivia: loaded.numberTrivia);
    } else if (provider.state is Error) {
      final Error error = provider.state as Error;
      return MessageDisplay(message: error.message);
    }
  }
}
