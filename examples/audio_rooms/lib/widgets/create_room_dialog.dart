import 'package:audio_rooms/models/create_room_model.dart';
import 'package:flutter/material.dart';

class CreateRoomDialog extends StatefulWidget {
  const CreateRoomDialog({
    Key? key,
    required this.onCreatePressed,
  }) : super(key: key);

  final ValueChanged<CreateRoomModel> onCreatePressed;

  @override
  State<CreateRoomDialog> createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  late final TextEditingController _roomTitleController;
  late final TextEditingController _roomDescriptionController;

  @override
  void initState() {
    super.initState();
    _roomTitleController = TextEditingController();
    _roomDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _roomTitleController.dispose();
    _roomDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const vh20 = SizedBox(height: 20);
    const vh12 = SizedBox(height: 12);
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(24.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 12.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              vh20,
              const Text('Room Name'),
              TextField(
                controller: _roomTitleController,
              ),
              vh12,
              const Text('Room Description'),
              TextField(
                controller: _roomDescriptionController,
              ),
              vh20,
              ListenableBuilder(
                listenable: Listenable.merge([
                  _roomDescriptionController,
                  _roomTitleController,
                ]),
                builder: (
                  BuildContext context,
                  Widget? child,
                ) {
                  final title = _roomTitleController.value.text;
                  final desc = _roomDescriptionController.value.text;
                  final fieldsNotEmpty = title.isNotEmpty && desc.isNotEmpty;

                  return ElevatedButton(
                    onPressed: fieldsNotEmpty
                        ? () {
                            Navigator.of(context).pop();
                            widget.onCreatePressed(
                              CreateRoomModel(title: title, desc: desc),
                            );
                          }
                        : null,
                    child: const Text('Create Room'),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
