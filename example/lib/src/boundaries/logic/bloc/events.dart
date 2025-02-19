enum Events {
  init,
  emit,
  togglePainter,
  toggleCloud,
  selectActiveSettings,
  addNewSettings,
  removeSelectedSettings,
  toggleImageSelection,
  updateOpacity,
  loadImage,
  loadImages,
  applySettings,
}

class RootBundleEvent {
  const RootBundleEvent(this.filePath);

  final String filePath;
}
