import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:simple_accounting_offline/src/account/application/account_service.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';
import 'package:simple_accounting_offline/src/seat/application/seat_service.dart';
import 'package:simple_accounting_offline/src/seat/domain/seat.dart';
import 'package:simple_accounting_offline/src/seat_detail/application/seat_detail_service.dart';
import 'package:simple_accounting_offline/src/seat_detail/domain/seat_detail.dart';
import 'package:simple_accounting_offline/ui/pages/pdf_income_statement/cubit/pdf_income_statement_state.dart';

class PDFJournalBookCubit extends Cubit<PDFIncomeStatementState> {
  PDFJournalBookCubit(
    this._accountService,
    this._seatService,
    this._seatDetailService, {
    this.startDate,
    this.endDate,
  }) : super(const PDFIncomeStatementState());

  final String? startDate;
  final String? endDate;

  final AccountService _accountService;
  final SeatService _seatService;
  final SeatDetailService _seatDetailService;

  void changeDownloading({required bool downloading}) {
    emit(state.copyWith(downloading: downloading));
  }

  Future<Uint8List> getDoc() async {
    final DateTime now = DateTime.now();
    final DateTime start = DateTime.tryParse(startDate ?? '') ??
        DateTime(
          now.year,
          now.month,
        );
    final DateTime end = DateTime.tryParse(endDate ?? '') ??
        DateTime(
          now.year,
          now.month,
          now.day,
        );
    emit(state.copyWith(downloading: true));
    final List<Seat> seats = await _seatService.getByPeriod(
      startDate: start,
      endDate: end,
      onlyActives: true,
    );
    final List<SeatDetail> details = await _seatDetailService.getAllBySeatIds(
      seats.map((e) => e.id!).toList(),
    );
    final List<Account> accounts = await _accountService.getByIds(
      details.map((e) => e.accountId).toSet().toList(),
    );
    for (int i = 0; i < details.length; i++) {
      details[i] = details[i].copyWith(
        account: accounts
            .firstWhereOrNull((element) => element.id == details[i].accountId),
      );
    }
    for (int i = 0; i < seats.length; i++) {
      seats[i] = seats[i].copyWith(
        seatDetails:
            details.where((element) => element.seatId == seats[i].id).toList(),
      );
      seats[i].seatDetails.removeWhere(
            (element) =>
                element.account?.accountCategoryId != 4 &&
                element.account?.accountCategoryId != 5,
          );
    }
    final Uint8List data = await compute(_generateJournalBookPDF, seats);
    emit(state.copyWith(file: data, downloading: false));
    return data;
  }
}

Future<Uint8List> _generateJournalBookPDF(List<Seat> seats) async {
  Decimal totalDebit = Decimal.zero;
  Decimal totalCredit = Decimal.zero;
  final List<pw.TableRow> rows = [];
  for (int i = 0; i < seats.length; i++) {
    rows.add(
      pw.TableRow(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(DateFormat('MMM dd').format(seats[i].date)),
            ),
          ),
          pw.Text(''),
          pw.Center(child: pw.Text('--- ${i + 1} ---')),
          pw.Text(''),
          pw.Text(''),
        ],
      ),
    );
    for (final SeatDetail detail in seats[i].seatDetails) {
      final Decimal credit = Decimal.parse(detail.credit.toString());
      final Decimal debit = Decimal.parse(detail.debit.toString());
      if (credit != Decimal.zero) totalCredit += credit;
      if (debit != Decimal.zero) totalDebit += debit;
      rows.add(
        pw.TableRow(
          children: [
            pw.Text(''),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4.0),
              child: pw.Text(detail.account?.code ?? ''),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4.0),
              child: pw.Text(
                credit == Decimal.zero
                    ? detail.account?.name ?? ''
                    : '    ${detail.account?.name}',
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4.0),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  debit == Decimal.zero
                      ? ''
                      : NumberFormat('#,##0.00').format(debit.toDouble()),
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4.0),
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  credit == Decimal.zero
                      ? ''
                      : NumberFormat('#,##0.00').format(
                          credit.toDouble(),
                        ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    // Add the description of the seat
    rows.add(
      pw.TableRow(
        children: [
          pw.Text(''),
          pw.Text(''),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 4.0),
            child: pw.Text(seats[i].description ?? ''),
          ),
          pw.Text(''),
          pw.Text(''),
        ],
      ),
    );
  }

  //Create Document
  final pw.Document doc = pw.Document();
  final pw.Font font = await PdfGoogleFonts.poppinsLight();
  doc.addPage(
    pw.MultiPage(
      theme: pw.ThemeData.withFont(
        base: font,
      ),
      margin: const pw.EdgeInsets.all(35),
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return [
          pw.Center(
            child: pw.Text(
              'Libro Diario',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 20.0,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 10.0),
          pw.Center(
            child: pw.Text(
              '${DateFormat('dd/MM/yyyy').format(
                seats.firstOrNull?.date ?? DateTime.now(),
              )}  -  ${DateFormat('dd/MM/yyyy').format(
                seats.lastOrNull?.date ?? DateTime.now(),
              )}',
            ),
          ),
          pw.Divider(),
          // Table data.
          pw.Table(
            border: const pw.TableBorder(
              verticalInside: pw.BorderSide(),
              right: pw.BorderSide(),
              bottom: pw.BorderSide(),
              left: pw.BorderSide(),
              top: pw.BorderSide(),
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.1),
              1: const pw.FlexColumnWidth(1.2),
              2: const pw.FlexColumnWidth(4.2),
              3: const pw.FlexColumnWidth(1.4),
              4: const pw.FlexColumnWidth(1.4),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  color: const PdfColor.fromInt(0xFFFFE599),
                ),
                repeat: true,
                children: [
                  pw.Center(child: pw.Text('Fecha')),
                  pw.Center(child: pw.Text('Código')),
                  pw.Center(child: pw.Text('Descripción')),
                  pw.Center(child: pw.Text('Debe')),
                  pw.Center(child: pw.Text('Haber')),
                ],
              ),
              ...rows,
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  color: const PdfColor.fromInt(0xFFFD9EAD3),
                ),
                children: [
                  pw.Text(''),
                  pw.Text(''),
                  pw.Text(
                    'Sumas iguales',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 4.0),
                    child: pw.Text(
                      NumberFormat('#,##0.00').format(
                        totalDebit.toDouble(),
                      ),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 4.0),
                    child: pw.Text(
                      NumberFormat('#,##0.00').format(
                        totalCredit.toDouble(),
                      ),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ];
      },
    ),
  );
  return doc.save();
}
