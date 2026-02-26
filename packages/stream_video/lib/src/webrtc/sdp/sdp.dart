sealed class Sdp {
  const Sdp(this.value);

  final String value;

  SdpType get type;

  static LocalOfferSdp localOffer(String sdp) => LocalOfferSdp(sdp);

  static LocalAnswerSdp localAnswer(
    String sdp, {
    String? offerSdp,
  }) => LocalAnswerSdp(sdp, offerSdp: offerSdp);

  static RemoteOfferSdp remoteOffer(String sdp) => RemoteOfferSdp(sdp);

  static RemoteAnswerSdp remoteAnswer(String sdp) => RemoteAnswerSdp(sdp);
}

class LocalOfferSdp extends Sdp {
  const LocalOfferSdp(super.value);

  @override
  SdpType get type => SdpType.localOffer;
}

class LocalAnswerSdp extends Sdp {
  const LocalAnswerSdp(super.value, {this.offerSdp});

  final String? offerSdp;

  @override
  SdpType get type => SdpType.localAnswer;
}

class RemoteOfferSdp extends Sdp {
  const RemoteOfferSdp(super.value);

  @override
  SdpType get type => SdpType.remoteOffer;
}

class RemoteAnswerSdp extends Sdp {
  const RemoteAnswerSdp(super.value);

  @override
  SdpType get type => SdpType.remoteAnswer;
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
