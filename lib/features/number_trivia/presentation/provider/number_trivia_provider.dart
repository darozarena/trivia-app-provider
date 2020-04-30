import 'package:dartz/dartz.dart';
import 'package:trivia_app/core/error/failures.dart';
import 'package:trivia_app/core/usecases/usecase.dart';
import 'package:trivia_app/core/util/input_converter.dart';
import 'package:trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia_app/features/number_trivia/presentation/provider/base_provider.dart';
import 'package:meta/meta.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero';

class NumberTriviaProvider extends BaseProvider {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaProvider({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  void getTriviaForConcreteNumber(String numberString) {
    setState(Loading());
    final inputEither = inputConverter.stringToUnsignedInteger(numberString);
    inputEither.fold((failure) {
      setState(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
    }, (integer) async {
      final failureOrTrivia =
          await getConcreteNumberTrivia(Params(number: integer));
      _eitherLoadedOrErrorState(failureOrTrivia);
    });
  }

  void getTriviaForRandomNumber() async {
    setState(Loading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    _eitherLoadedOrErrorState(failureOrTrivia);
  }

  void _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia) {
    failureOrTrivia.fold(
        (failure) => setState(Error(message: _mapFailureToMessage(failure))),
        (trivia) => setState(Loaded(numberTrivia: trivia)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
