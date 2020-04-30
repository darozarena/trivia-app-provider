import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trivia_app/features/number_trivia/presentation/provider/base_provider.dart';
import 'package:trivia_app/injection_container.dart';

class BasePage<T extends BaseProvider> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T) onModelReady;

  BasePage({this.builder, this.onModelReady});

  @override
  _BasePageState<T> createState() => _BasePageState<T>();
}

class _BasePageState<T extends BaseProvider> extends State<BasePage<T>> {
  T model = sl<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        create: (context) => model,
        child: Consumer<T>(builder: widget.builder));
  }
}
