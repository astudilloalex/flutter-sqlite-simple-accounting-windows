import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_accounting_offline/app/services/get_it_service.dart';
import 'package:simple_accounting_offline/app/services/get_storage_service.dart';
import 'package:simple_accounting_offline/src/account/application/account_service.dart';
import 'package:simple_accounting_offline/src/seat/application/seat_service.dart';
import 'package:simple_accounting_offline/src/seat_detail/application/seat_detail_service.dart';
import 'package:simple_accounting_offline/src/user/application/user_service.dart';
import 'package:simple_accounting_offline/ui/pages/home/cubit/home_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/home/home_page.dart';
import 'package:simple_accounting_offline/ui/pages/pdf_income_statement/cubit/pdf_income_statement_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/pdf_income_statement/pdf_income_statement_page.dart';
import 'package:simple_accounting_offline/ui/pages/pdf_journal_book/cubit/pdf_journal_book_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/pdf_journal_book/pdf_journal_book_page.dart';
import 'package:simple_accounting_offline/ui/pages/sign_in/cubit/sign_in_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/sign_in/sign_in_page.dart';
import 'package:simple_accounting_offline/ui/pages/splash/cubit/splash_cubit.dart';
import 'package:simple_accounting_offline/ui/pages/splash/splash_page.dart';
import 'package:simple_accounting_offline/ui/routes/route_name.dart';

class RoutePage {
  const RoutePage._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteName.splash,
    routes: [
      GoRoute(
        name: RouteName.home,
        path: RouteName.home,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => HomeCubit(getIt<GetStorageService>()),
            child: const HomePage(),
          );
        },
      ),
      GoRoute(
        name: RouteName.pdfIncomeStatement,
        path: RouteName.pdfIncomeStatement,
        builder: (context, state) => BlocProvider(
          create: (_) => PDFIncomeStatementCubit(
            getIt<AccountService>(),
            getIt<SeatService>(),
            getIt<SeatDetailService>(),
            startDate: state.queryParams['start_date'],
            endDate: state.queryParams['end_date'],
          ),
          child: const PDFIncomeStatementPage(),
        ),
      ),
      GoRoute(
        name: RouteName.pdfJourneyBook,
        path: RouteName.pdfJourneyBook,
        builder: (context, state) => BlocProvider(
          create: (_) => PDFJournalBookCubit(
            getIt<AccountService>(),
            getIt<SeatService>(),
            getIt<SeatDetailService>(),
            startDate: state.queryParams['start_date'],
            endDate: state.queryParams['end_date'],
          ),
          child: const PDFJournalBookPage(),
        ),
      ),
      GoRoute(
        name: RouteName.splash,
        path: RouteName.splash,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => SplashCubit(
              getIt<UserService>(),
              getIt<GetStorageService>(),
            ),
            child: const SplashPage(),
          );
        },
      ),
      GoRoute(
        name: RouteName.signIn,
        path: RouteName.signIn,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => SignInCubit(
              getIt<UserService>(),
              getIt<GetStorageService>(),
            ),
            child: const SignInPage(),
          );
        },
      ),
    ],
  );
}
