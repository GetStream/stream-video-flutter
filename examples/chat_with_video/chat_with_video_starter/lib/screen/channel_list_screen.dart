import 'package:flutter/material.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({
    Key? key,
    required this.onLogout,
  }) : super(key: key);

  final VoidCallback onLogout;

  @override
  State<ChannelListScreen> createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  /// TODO: Add StreamChannelListController here.

  @override
  Widget build(BuildContext context) {
    /// TODO: Add channel list UI here.
    return SizedBox();
  }
}
