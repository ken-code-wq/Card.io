import 'package:vibration/vibration.dart';

vibrate({required int duration, required int amplitude}) async {
  // HapticFeedback.lightImpact();
  if (await Vibration.hasVibrator() ?? true) {
    Vibration.vibrate(
      duration: duration,
      amplitude: amplitude,
    );
  }
}
//For tapping buttons
//For sliding sliders
//For hitting milestone
//For getting quiz questions correct or wrong