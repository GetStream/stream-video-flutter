class Sdp {
  const Sdp(this.type, this.value);

  const Sdp.localOffer(String sdp) : this(SdpType.localOffer, sdp);

  const Sdp.localAnswer(String sdp) : this(SdpType.localAnswer, sdp);

  const Sdp.remoteOffer(String sdp) : this(SdpType.remoteOffer, sdp);

  const Sdp.remoteAnswer(String sdp) : this(SdpType.remoteAnswer, sdp);

  final SdpType type;
  final String value;
}

enum SdpType {
  localOffer,
  localAnswer,
  remoteOffer,
  remoteAnswer;

  @override
  String toString() => name;
}

typedef SdpLine = String;
