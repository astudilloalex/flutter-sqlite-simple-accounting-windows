import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:simple_accounting_offline/ui/pages/pdf_journal_book/cubit/pdf_journal_book_cubit.dart';

class PDFJournalBookPage extends StatelessWidget {
  const PDFJournalBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.journalBook),
      ),
      body: PdfPreview(
        pdfFileName: 'journal_book',
        canChangeOrientation: false,
        canDebug: false,
        pageFormats: const {
          'A4': PdfPageFormat.a4,
        },
        build: (_) => context.read<PDFJournalBookCubit>().getDoc(),
        maxPageWidth: 1000.0,
        actions: [
          if (!context.watch<PDFJournalBookCubit>().state.downloading)
            IconButton(
              iconSize: 20,
              onPressed: () async {
                const String fileName = 'journal_book';
                final Uint8List? data =
                    context.read<PDFJournalBookCubit>().state.file;
                final String? path = await getSavePath(suggestedName: fileName);
                if (path == null || data == null) return;
                final XFile file = XFile.fromData(
                  data,
                  mimeType: 'application/pdf',
                  name: fileName,
                );
                if (context.mounted) {
                  context.read<PDFJournalBookCubit>().changeDownloading(
                        downloading: true,
                      );
                }
                await file.saveTo('$path.pdf');
                if (context.mounted) {
                  context.read<PDFJournalBookCubit>().changeDownloading(
                        downloading: false,
                      );
                }
              },
              icon: const Icon(Icons.download_outlined),
            ),
        ],
      ),
    );
  }
}
