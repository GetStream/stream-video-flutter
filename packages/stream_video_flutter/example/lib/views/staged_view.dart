import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class CallArgs {
  final String callId;
  CallArgs({required this.callId});
}

class StagedView extends StatelessWidget {
  final ParticipantController controller;
  static String routeName = "/stagedView";

  const StagedView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CallArgs;
    // controller.room.participants.
    // args.call.payload.call.

    final List<Map> myProducts = List.generate(
        100000, (index) => {"id": index, "name": "Product $index"}).toList();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: myProducts.length,
              itemBuilder: (BuildContext ctx, index) {
                return ParticipantView(myProducts: myProducts, index: index);
              }),
        ),
      ),
    );
  }
}

class ParticipantView extends StatelessWidget {
  const ParticipantView({
    Key? key,
    required this.myProducts,
    required this.index,
  }) : super(key: key);

  final List<Map> myProducts;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.amber, borderRadius: BorderRadius.circular(15)),
      child: Text(myProducts[index]["name"]),
    );
  }
}
