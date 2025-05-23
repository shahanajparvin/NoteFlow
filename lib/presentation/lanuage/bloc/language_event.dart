import 'package:equatable/equatable.dart';
import 'package:noteflow/domain/entities/other/language.dart';


abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class ChangeLanguage extends LanguageEvent {
  const ChangeLanguage({required this.selectedLanguage});

  final Language selectedLanguage;

  @override
  List<Object> get props => [selectedLanguage];
}


