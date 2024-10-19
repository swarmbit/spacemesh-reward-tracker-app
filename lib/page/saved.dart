import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../component/account_card.dart';
import '../provider/accounts_provider.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AccountsProvider>();
    var saved = appState.savedAccounts;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: Column(
        children: [
          const SizedBox(height: 15),
          saved.isEmpty
              ? const Expanded(
                  child: Center(child: Text('No saved accounts yet!')))
              : Expanded(
                  child: ListView.builder(
                    itemCount: saved.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AccountCard(
                        address: saved[index].address,
                        icon: Icons.cancel_outlined,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
