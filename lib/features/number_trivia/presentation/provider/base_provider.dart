import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:trivia_app/features/number_trivia/domain/entities/number_trivia.dart';

part 'base_state_provider.dart';

class BaseProvider extends ChangeNotifier {
  NumberTriviaState _state = Empty();

  NumberTriviaState get state => _state;

  void setState(NumberTriviaState numberTriviaState) {
    _state = numberTriviaState;
    notifyListeners();
  }
}
