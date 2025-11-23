import 'package:equatable/equatable.dart';

class ShareContent extends Equatable {
  final String shareUrl;
  final String shortUrl;
  final String deepLink;
  final String shareText;
  final PlatformSpecificUrls platformSpecific;
  final String qrCode;
  final DateTime generatedAt;

  const ShareContent({
    required this.shareUrl,
    required this.shortUrl,
    required this.deepLink,
    required this.shareText,
    required this.platformSpecific,
    required this.qrCode,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [
        shareUrl,
        shortUrl,
        deepLink,
        shareText,
        platformSpecific,
        qrCode,
        generatedAt,
      ];
}

class PlatformSpecificUrls extends Equatable {
  final String whatsapp;
  final String facebook;
  final String twitter;
  final String instagram;

  const PlatformSpecificUrls({
    required this.whatsapp,
    required this.facebook,
    required this.twitter,
    required this.instagram,
  });

  @override
  List<Object?> get props => [whatsapp, facebook, twitter, instagram];
}
