import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../core/repos/app_preferences.dart';
import '../di/injector.dart';
import '../widgets/stream_button.dart';

class CallParticipantsList extends StatelessWidget {
  const CallParticipantsList({super.key, required this.call});

  final Call call;

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final textTheme = streamVideoTheme.textTheme;

    return StreamBuilder<CallState>(
      initialData: call.state.value,
      stream: call.state.asStream(),
      builder: (context, snapshot) {
        final callState = snapshot.requireData;
        final participants = callState.callParticipants;

        final participantIds = participants.map((p) => p.userId).toSet();
        final membersNotInCall = callState.callMembers
            .where((member) => !participantIds.contains(member.userId))
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Participants (${participants.length})',
              style: textTheme.title3.apply(color: Colors.white),
            ),
            centerTitle: true,
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 16),
                  children: [
                    for (final participant in participants)
                      _ParticipantTile(
                        participant: participant,
                        theme: streamVideoTheme,
                      ),
                    if (membersNotInCall.isNotEmpty) ...[
                      const Divider(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Members not in call (${membersNotInCall.length})',
                          style: textTheme.title3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      for (final member in membersNotInCall)
                        _MemberTile(
                          member: member,
                          theme: streamVideoTheme,
                          onRing: () => _ringMember(context, member),
                        ),
                    ],
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        // Builder provides the button's own context so the
                        // share sheet can be anchored to the button.
                        child: Builder(
                          builder: (buttonContext) => StreamButton.tertiary(
                            icon: const Icon(
                              Icons.link,
                              color: Colors.white,
                            ),
                            label: 'Share link',
                            onPressed: () => _shareLink(buttonContext),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StreamButton.active(
                          icon: const Icon(
                            Icons.person_add_alt_1,
                            color: Colors.white,
                          ),
                          label: 'Add member',
                          onPressed: () => _showAddMemberDialog(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _shareLink(BuildContext context) async {
    final appPreferences = locator.get<AppPreferences>();
    final callUrl = appPreferences.environment.getJoinUrl(callId: call.id);

    if (callUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No shareable link for this call')),
      );
      return;
    }

    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    await SharePlus.instance.share(
      ShareParams(
        uri: Uri.parse(callUrl),
        sharePositionOrigin: origin,
      ),
    );
  }

  Future<void> _ringMember(
    BuildContext context,
    CallMemberState member,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await call.ring(userIds: [member.userId]);

    result.fold(
      success: (_) {
        messenger.showSnackBar(
          SnackBar(content: Text('Ringing ${member.name}...')),
        );
      },
      failure: (failure) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'Failed to ring ${member.name}: ${failure.error.message}',
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddMemberDialog(BuildContext context) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);

    final userId = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Text(
            'Enter the ID of the member you want to add',
            style: theme.textTheme.bodyLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'User ID',
                  hintStyle: TextStyle(color: Colors.white30),
                ),
                onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 150,
                  child: StreamButton.active(
                    label: 'Add',
                    icon: const Icon(
                      Icons.person_add_alt_1,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        Navigator.of(context).pop(controller.text.trim()),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (userId == null || userId.isEmpty) return;
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final result = await call.addMembers([UserInfo(id: userId)]);

    result.fold(
      success: (_) {
        messenger.showSnackBar(
          SnackBar(content: Text('Added $userId to the call')),
        );
      },
      failure: (failure) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Failed to add $userId: ${failure.error.message}'),
          ),
        );
      },
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  const _ParticipantTile({
    required this.participant,
    required this.theme,
  });

  final CallParticipantState participant;
  final StreamVideoTheme theme;

  @override
  Widget build(BuildContext context) {
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          StreamUserAvatarTheme(
            data: theme.userAvatarTheme,
            child: StreamUserAvatar(
              user: UserInfo(
                id: participant.userId,
                name: participant.name.ifEmpty(() => participant.userId),
                image: participant.image,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participant.name.ifEmpty(() => participant.userId),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    participant.roles.join(', '),
                    style: textTheme.footnoteItalic,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          if (participant.isAudioEnabled)
            const Icon(Icons.mic_rounded)
          else
            const Icon(Icons.mic_off_rounded),
          const SizedBox(width: 8),
          if (participant.isVideoEnabled)
            const Icon(Icons.videocam_rounded)
          else
            const Icon(Icons.videocam_off_rounded),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.member,
    required this.theme,
    required this.onRing,
  });

  final CallMemberState member;
  final StreamVideoTheme theme;
  final VoidCallback onRing;

  @override
  Widget build(BuildContext context) {
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          StreamUserAvatarTheme(
            data: theme.userAvatarTheme,
            child: StreamUserAvatar(
              user: UserInfo(
                id: member.userId,
                name: member.name.ifEmpty(() => member.userId),
                image: member.image,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name.ifEmpty(() => member.userId),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    member.roles.join(', '),
                    style: textTheme.footnoteItalic,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(Icons.notifications_active_outlined),
            label: const Text('Ring'),
            onPressed: onRing,
          ),
        ],
      ),
    );
  }
}
