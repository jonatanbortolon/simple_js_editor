class FormatDuration {
  static format(int ms) {
    if (ms / 86400000 > 1) {
      return "${(ms / 86400000).toStringAsFixed(2)} ${(ms / 86400000) > 2 ? 'days' : "day"}";
    } else if (ms / 3600000 > 1) {
      return "${(ms / 86400000).toStringAsFixed(2)}h";
    } else if (ms / 60000 > 1) {
      return "${(ms / 60000).toStringAsFixed(2)}m";
    } else if (ms / 1000 > 1) {
      return "${(ms / 1000).toStringAsFixed(2)}s";
    } else {
      return "${ms}ms";
    }
  }
}
