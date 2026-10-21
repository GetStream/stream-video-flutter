import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// The base of every event the SDK delivers.
///
/// `StreamVideo.events` carries the coordinator connection events and the
/// call events for every call the user is involved in. `Call.callEvents`
/// carries the call events — from the coordinator and from the SFU — for that
/// one call.
@immutable
abstract class StreamVideoEvent extends Equatable {
  const StreamVideoEvent();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [];
}
