import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/account.dart';
import '../provider/settings_provider.dart';
import '../service/account_service.dart';

class FindAccountForm extends StatefulWidget {
  const FindAccountForm({Key? key, required this.onSearch}) : super(key: key);

  final void Function(Account? a) onSearch;

  @override
  FindAccountFormState createState() => FindAccountFormState();
}

class FindAccountFormState extends State<FindAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  var _isSearching = false;

  AccountService accountService = AccountService();

  void _onSearch(Account? account) {
    if (mounted) {
      widget.onSearch(account);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var brightness =
        Provider.of<SettingsProvider>(context).getSelectedBrightness(
      MediaQuery.of(context).platformBrightness,
    );

    Color fillColor;
    switch (brightness) {
      case Brightness.light:
        fillColor = theme.primaryColor.withOpacity(0.1);
        break;
      case Brightness.dark:
        fillColor = Colors.teal.withOpacity(0.2);
        break;
    }

    return Semantics(
      label: 'Type or paste an account address to find it.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                label: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('Account address'),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isSearching = true);

                        accountService
                            .getAccount(_controller.text)
                            .then((value) {
                          _isSearching = false;
                          _onSearch(value);
                        }).onError((error, stackTrace) {
                          setState(() {
                            _isSearching = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to fetch account!'),
                            ),
                          );
                        });
                      }
                    },
                    icon: _isSearching
                        ? const CircularProgressIndicator(
                            backgroundColor: Colors.transparent,
                          )
                        : const Icon(Icons.search),
                  ),
                ),
                filled: true,
                fillColor: fillColor,
              ),
              controller: _controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid account address';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
