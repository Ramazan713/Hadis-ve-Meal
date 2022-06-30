

class AdUtil{
  
  // test Ids
  static const interstitialAdId='ca-app-pub-3940256099942544/1033173712';
  static const bannerAdId="ca-app-pub-3940256099942544/6300978111";

  static const tickIntervalSeconds=10;
  static const _thresholdConsumeSeconds=60*5;
  static const _thresholdOpeningCounter=13;
  static int _counterOpening=0;
  static int _totalConsumeSeconds=0;

  static bool increaseConsumeSeconds(){
    _totalConsumeSeconds+=tickIntervalSeconds;
    return _checkThreshold();
  }
  static bool increaseOpeningCounter(){
    _counterOpening++;
    return _checkThreshold();
  }

  static bool _checkThreshold(){
    return _counterOpening>=_thresholdOpeningCounter
      || _totalConsumeSeconds>=_thresholdConsumeSeconds;
  }

  static resetValues(){
    _counterOpening=0;
    _totalConsumeSeconds=0;
  }
}