import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../index.dart';

class AccountImporterContainer extends StatelessWidget {
  final ValueChanged? onImported;

  const AccountImporterContainer({Key? key, this.onImported}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AccountImporterCubit, AccountImporterState>(
        builder: (context, state) {
      final importer = context.read<AccountImporterCubit>();
      if (state.status.isSubmissionInProgress) {
        return const CircularProgressIndicator().center();
      } else if (state.status.isSubmissionFailure) {
        return Text(state.exception?.message ?? '')
            .textColor(theme.errorColor)
            .center();
      }
      return Wrap(
        children: [
          ElevatedButton(
                  onPressed: () => importer.import("path"),
                  child: const Text("导入"))
              .center(),
          Text(state.account.address).center(),
          if (!state.account.isEmpty)
            ElevatedButton(
                    onPressed: () => onImported?.call(state.account),
                    child: const Text("确认导入"))
                .center()
        ],
      );
    });
  }
}
