part of 'theme_cubit.dart';

abstract class ThemeState extends Equatable {
  final bool newTheme;
  const ThemeState(
    this.newTheme,
  );

  @override
  List<Object> get props => [newTheme];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial() : super(true);
}

class ChangeAppThemeState extends ThemeState {
  const ChangeAppThemeState(super.newTheme);
}
