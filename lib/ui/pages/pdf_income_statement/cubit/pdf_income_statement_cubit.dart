import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class PDFIncomeStatementCubit extends Cubit<PDFIncomeStatementState> {
  PDFIncomeStatementCubit(
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
        seat: seats
            .firstWhereOrNull((element) => element.id == details[i].seatId),
      );
    }
    details.removeWhere(
      (element) =>
          element.account?.accountCategoryId != 4 &&
          element.account?.accountCategoryId != 5,
    );
    details.sort((a, b) => a.seat!.date.compareTo(b.seat!.date));
    final Uint8List data = await compute(
      _generateJournalBookPDF,
      details,
    );
    emit(state.copyWith(file: data, downloading: false));
    return data;
  }
}

Future<Uint8List> _generateJournalBookPDF(List<SeatDetail> seatDetails) async {
  final Map<String, List<SeatDetail>> grouped = groupBy(
    seatDetails,
    (detail) => detail.account!.code,
  );
  final List<SeatDetail> details = [];
  for (final List<SeatDetail> group in grouped.values) {
    Decimal totalDebit = Decimal.zero;
    Decimal totalCredit = Decimal.zero;
    for (final SeatDetail detail in group) {
      totalCredit += Decimal.parse(detail.credit.toString());
      totalDebit += Decimal.parse(detail.debit.toString());
    }
    final SeatDetail? detail = group.firstOrNull;
    if (detail != null) {
      details.add(
        detail.copyWith(
          credit: totalCredit.toDouble(),
          debit: totalDebit.toDouble(),
        ),
      );
    }
  }
  final List<SeatDetail> incomes = details
      .where((element) => element.account?.accountCategoryId == 4)
      .toList();
  final List<SeatDetail> expenses = details
      .where((element) => element.account?.accountCategoryId == 5)
      .toList();
  final List<pw.TableRow> rows = [];
  rows.add(
    pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              'INGRESOS',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ),
        pw.Text(''),
      ],
    ),
  );
  Decimal totalIncomes = Decimal.zero;
  Decimal totalExpenses = Decimal.zero;
  for (final SeatDetail detail in incomes) {
    totalIncomes += Decimal.parse(detail.credit.toString()) -
        Decimal.parse(detail.debit.toString());
    rows.add(
      pw.TableRow(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(detail.account?.name ?? ''),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                NumberFormat('#,##0.00').format(
                  (Decimal.parse(detail.credit.toString()) -
                          Decimal.parse(detail.debit.toString()))
                      .toDouble(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  rows.add(
    pw.TableRow(
      children: [
        pw.DecoratedBox(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
            color: PdfColor.fromHex('D9EAD3'),
          ),
          child: pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                'TOTAL INGRESOS',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        pw.DecoratedBox(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
            color: PdfColor.fromHex('D9EAD3'),
          ),
          child: pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                NumberFormat('#,##0.00').format(
                  totalIncomes.toDouble(),
                ),
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  rows.add(
    pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              'GASTOS',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ),
        pw.Text(''),
      ],
    ),
  );
  for (final SeatDetail detail in expenses) {
    totalExpenses += Decimal.parse(detail.debit.toString()) -
        Decimal.parse(detail.credit.toString());
    rows.add(
      pw.TableRow(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(detail.account?.name ?? ''),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                NumberFormat('#,##0.00').format(
                  (Decimal.parse(detail.debit.toString()) -
                          Decimal.parse(detail.credit.toString()))
                      .toDouble(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  rows.add(
    pw.TableRow(
      children: [
        pw.DecoratedBox(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
            color: PdfColor.fromHex('F4CCCC'),
          ),
          child: pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                'TOTAL GASTOS',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        pw.DecoratedBox(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
            color: PdfColor.fromHex('F4CCCC'),
          ),
          child: pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                NumberFormat('#,##0.00').format(
                  totalExpenses.toDouble(),
                ),
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

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
              'Estado de resultados',
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
                details.firstOrNull?.seat?.date ?? DateTime.now(),
              )}  -  ${DateFormat('dd/MM/yyyy').format(
                details.lastOrNull?.seat?.date ?? DateTime.now(),
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
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  color: const PdfColor.fromInt(0xFFFFE599),
                ),
                repeat: true,
                children: [
                  pw.Center(child: pw.Text('Descripción')),
                  pw.Center(child: pw.Text('Valores')),
                ],
              ),
              ...rows,
              // pw.TableRow(
              //   decoration: pw.BoxDecoration(
              //     border: pw.Border.all(),
              //     color: const PdfColor.fromInt(0xFFFD9EAD3),
              //   ),
              //   children: [
              //     pw.Text(''),
              //     pw.Text(''),
              //     pw.Text(
              //       'Sumas iguales',
              //       textAlign: pw.TextAlign.center,
              //       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              //     ),
              //     pw.Padding(
              //       padding: const pw.EdgeInsets.symmetric(horizontal: 4.0),
              //       child: pw.Text(
              //         NumberFormat('#,##0.00').format(
              //           totalDebit.toDouble(),
              //         ),
              //         textAlign: pw.TextAlign.right,
              //         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              //       ),
              //     ),
              //     pw.Padding(
              //       padding: const pw.EdgeInsets.symmetric(horizontal: 4.0),
              //       child: pw.Text(
              //         NumberFormat('#,##0.00').format(
              //           totalCredit.toDouble(),
              //         ),
              //         textAlign: pw.TextAlign.right,
              //         style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ];
      },
    ),
  );
  return doc.save();
}
