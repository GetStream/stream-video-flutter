class Sdp {
  const Sdp(this.type, this.value);

  factory Sdp.localOffer(String sdp) => Sdp(SdpType.localOffer, sdp);

  factory Sdp.localAnswer(String sdp) => Sdp(SdpType.localAnswer, sdp);

  factory Sdp.remoteOffer(String sdp) => Sdp(SdpType.remoteOffer, sdp);

  factory Sdp.remoteAnswer(String sdp) => Sdp(SdpType.remoteAnswer, sdp);

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
