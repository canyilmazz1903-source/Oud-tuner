import 'dart:math';

class CentsCalculator {
  static double calculateCents(double currentFreq, double targetFreq) {
    if (currentFreq <= 0 || targetFreq <= 0) return 0.0;
    return 1200 * (log(currentFreq / targetFreq) / log(2));
  }
}
