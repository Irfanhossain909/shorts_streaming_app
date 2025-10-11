class EpisodSelectBtnModel {
  final bool isRunning;
  final bool isAvailable;
  final bool isLock;
  final String text;

  EpisodSelectBtnModel({
    required this.text,
    this.isRunning = false,
    this.isAvailable = false,
    this.isLock = false,
  });
}

List<EpisodSelectBtnModel> episodSelectBtnList = List.generate(25, (index) {
  if (index == 0) {
    // First item running
    return EpisodSelectBtnModel(text: "${index + 1}", isRunning: true);
  } else if (index >= 1 && index <= 4) {
    // Next 4 items available
    return EpisodSelectBtnModel(
      text: "${index + 1}",
      isLock: true,
      isAvailable: true,
    );
  } else {
    // Remaining items locked
    return EpisodSelectBtnModel(text: "${index + 1}", isLock: true);
  }
});
