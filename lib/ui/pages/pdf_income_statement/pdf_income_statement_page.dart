import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:simple_accounting_offline/ui/pages/pdf_income_statement/cubit/pdf_income_statement_cubit.dart';

class PDFIncomeStatementPage extends StatelessWidget {
  const PDFIncomeStatementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.incomeStatement),
      ),
      body: PdfPreview(
        pdfFileName: 'journal_book',
        canChangeOrientation: false,
        canDebug: false,
        pageFormats: const {
          'A4': PdfPageFormat.a4,
        },
        build: (_) => context.read<PDFIncomeStatementCubit>().getDoc(),
        maxPageWidth: 1000.0,
        actions: [
          IconButton(
            iconSize: 20,
            onPressed: () async {
              const String fileName = 'income_statement';
              final Uint8List? data =
                  context.read<PDFIncomeStatementCubit>().state.file;
              final String? path = await getSavePath(suggestedName: fileName);
              if (path == null || data == null) return;
              final XFile file = XFile.fromData(
                data,
                mimeType: 'application/pdf',
                name: fileName,
              );
              if (context.mounted) {
                context.read<PDFIncomeStatementCubit>().changeDownloading(
                      downloading: true,
                    );
              }
              await file.saveTo('$path.pdf');
              if (context.mounted) {
                context.read<PDFIncomeStatementCubit>().changeDownloading(
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
