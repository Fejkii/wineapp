part of 'theme_cubit.dart';

abstract class ThemeState extends Equatable {
  final bool isLightTehem;
  const ThemeState(
    this.isLightTehem,
  );

  @override
  List<Object> get props => [isLightTehem];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial(super.isLightTehem);
}

class ChangeAppThemeState extends ThemeState {
  const ChangeAppThemeState(super.isLightTehem);
}
