import 'package:flutter/material.dart';
import 'package:simple_accounting_offline/src/account/domain/account.dart';

class AccountSearchDelegate extends SearchDelegate<Account?> {
  AccountSearchDelegate({
    this.data = const [],
  });

  final List<Account> data;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Account> filter = data.where((element) {
      return element.code.toLowerCase().contains(query.toLowerCase()) ||
          element.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    return ListView.builder(
      itemCount: filter.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filter[index].name),
          trailing: Text(filter[index].code),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Account> filter = data.where((element) {
      return element.code.toLowerCase().contains(query.toLowerCase()) ||
          element.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    return ListView.builder(
      itemCount: filter.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filter[index].name),
          trailing: Text(filter[index].code),
        );
      },
    );
  }
}
