import 'dart:typed_data';

class PDFIncomeStatementState {
  const PDFIncomeStatementState({this.downloading = false, this.file});

  final bool downloading;
  final Uint8List? file;

  PDFIncomeStatementState copyWith({
    bool? downloading,
    Uint8List? file,
  }) {
    return PDFIncomeStatementState(
      downloading: downloading ?? this.downloading,
      file: file ?? this.file,
    );
  }
}
