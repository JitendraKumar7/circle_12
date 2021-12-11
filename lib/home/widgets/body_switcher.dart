part of '../index.dart';

class BodySwitcher extends StatelessWidget {
  final HomeState state;

  BodySwitcher(
    this.state, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        switchInCurve: Curves.easeInExpo,
        switchOutCurve: Curves.easeOutExpo,
        duration: Duration(milliseconds: 300),
        child: navigationItem.firstWhere(state.isEqual).body,
      );
}
