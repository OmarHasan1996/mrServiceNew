import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {

  static BannerAd? bannerAd;
  static InterstitialAd? interstitialAd;

  static despose(){
    if(AdHelper.interstitialAd!= null) AdHelper.interstitialAd?.dispose();
    if(AdHelper.bannerAd!= null) AdHelper.bannerAd?.dispose();
  }

  static String? get getBannerAdUnitId {
    if (Platform.isIOS) {
      //return 'ca-app-pub-3940256099942544/2934735716'; // test
      return 'ca-app-pub-5051441163313137/9983771734'; // mr. service
      //return 'ca-app-pub-5051441163313137/1086082504'; // closer
    } else if (Platform.isAndroid) {
      //return 'ca-app-pub-3940256099942544/6300978111'; // test
      return 'ca-app-pub-5051441163313137/2483727686'; // mr. Service
      //return 'ca-app-pub-5051441163313137/4753864776'; // closer
    }
    return null;
  }

  static String? get getInterstitialAdUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-5051441163313137/4854733985';// mr. Service
      return 'ca-app-pub-5051441163313137/3128957760';// closer
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5051441163313137/4488451213';// mr. Service
      return 'ca-app-pub-5051441163313137/3065378587';// closer
    }
    return null;
  }

  static String? get getRewardBasedVideoAdUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-5051441163313137/9915488976';// mr. Service
      return 'ca-app-pub-5051441163313137/6613741359';// closer
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5051441163313137/9961938045';// mr. Service
      return 'ca-app-pub-5051441163313137/3361672304';// closer
    }
    return null;
  }

  static loadBanner(){
    BannerAd(
      adUnitId: getBannerAdUnitId??'',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
            bannerAd = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  static loadInterstitialAd(Function() afterAdd){
    BannerAd(
      adUnitId: getBannerAdUnitId??'',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    InterstitialAd.load(
      adUnitId: getInterstitialAdUnitId??'',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              afterAdd();
            },
          );
          interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }
}