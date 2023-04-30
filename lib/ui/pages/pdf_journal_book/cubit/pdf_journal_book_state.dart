import 'dart:typed_data';

class PDFJournalBookState {
  const PDFJournalBookState({this.downloading = false, this.file});

  final bool downloading;
  final Uint8List? file;

  PDFJournalBookState copyWith({
    bool? downloading,
    Uint8List? file,
  }) {
    return PDFJournalBookState(
      downloading: downloading ?? this.downloading,
      file: file ?? this.file,
    );
  }
}
