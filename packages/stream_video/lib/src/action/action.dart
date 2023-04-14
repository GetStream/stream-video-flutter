import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class StreamAction extends Equatable {
  const StreamAction();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}
