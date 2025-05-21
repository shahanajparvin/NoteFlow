import 'package:noteflow/domain/repository/note_repository.dart';

abstract class NoteUseCase<T, R> {
  NoteUseCase({required this.repository});
  final NoteRepository repository;
  // ignore: unused_field
  T? _param;

  void setParam(T param) {
    this._param = param;
  }

  T? getParam() {
    return _param;
  }

  Future<R> execute();
}
