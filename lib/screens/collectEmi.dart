import 'dart:async';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';

class CollectEmi extends StatefulWidget {
  const CollectEmi({Key? key}) : super(key: key);

  @override
  State<CollectEmi> createState() => _CollectEmiState();
}

class _CollectEmiState extends State<CollectEmi> {
  String LogStat = '';
  bool _isInterstitialAdLoaded = false;
  bool isRewardLoaded = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // need to remove after final build
    FacebookAudienceNetwork.init(
        testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
        iOSAdvertiserTrackingEnabled: false //default false
        );
    _loadInterstitialAd();
    timer = Timer.periodic(
        const Duration(seconds: 15), (Timer t) => _showInterstitialAd());
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID",
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }

  void loadRewardAds() {}

  @override
  Widget build(BuildContext context) {
    return Container(
        child: const Text('emi collection form',
            style: TextStyle(color: Colors.white)));
  }

  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true) {
      FacebookInterstitialAd.showInterstitialAd();
    } else {
      print("Interstial Ad not yet loaded!");
    }
  }
}
