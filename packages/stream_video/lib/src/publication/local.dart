import 'package:collection/collection.dart';

import '../../protobuf/video/sfu/event/events.pbserver.dart' as sfu;
import '../logger/logger.dart';
import '../options.dart';
import '../participant/local.dart';
import '../track/local/local.dart';
import 'track_publication.dart';

/// A [TrackPublication] which belongs to the [LocalParticipant].
class LocalTrackPublication<T extends LocalTrack> extends TrackPublication<T> {
  /// Creates a new instance of [LocalTrackPublication].
  LocalTrackPublication({
    required this.participant,
    required super.info,
    required T track,
    required PublishOptions publishOptions,
  }) {
    updateTrack(track, publishOptions: publishOptions);
  }

  /// The [LocalParticipant] this instance belongs to.
  @override
  final LocalParticipant participant;

  /// Mute the track associated with this publication
  Future<void> mute() async => await track?.mute();

  /// Unmute the track associated with this publication
  Future<void> unmute() async => await track?.unmute();

  /// Updates the publishing layers.
  Future<void> updatePublishingLayers({
    required Iterable<sfu.VideoLayerSetting> layers,
  }) async {
    //
    logger.fine('Update publishing layers: $layers');

    final params = track?.sender?.parameters;
    if (params == null) {
      logger.fine('Update publishing layers: sender params are null');
      return;
    }

    final encodings = params.encodings;
    if (encodings == null) {
      logger.fine('Update publishing layers: encodings are null');
      return;
    }

    var didChange = false;
    for (final encoding in encodings) {
      logger.fine('Processing encoding: ${encoding.rid}...');
      final layer = layers.firstWhereOrNull((it) {
        return (it.name == encoding.rid) ||
            // Use low layer if rid is null (not simulcast)
            (encoding.rid == null && it.name == 'q');
      });
      if (layer != null && encoding.active != layer.active) {
        encoding.active = layer.active;
        logger.fine('Setting layer ${layer.name} to ${layer.active}');
        // FireFox does not support setting encoding.active to false, so we
        // have a workaround of lowering its bitrate and resolution to the min.
        // TODO: Workaround for firefox
        didChange = true;
      }
    }

    if (didChange) {
      params.encodings = encodings;
      final result = await track?.sender?.setParameters(params);
      if (result == false) {
        logger.warning('Failed to update sender parameters');
      }
    } else {
      logger.fine('Update publishing layers: nothing to change');
    }
  }
}
