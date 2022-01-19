import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../../index.dart';
import 'package:styled_widget/styled_widget.dart';

class AccountGeneratorContainer extends StatelessWidget {
  const AccountGeneratorContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountGeneratorCubit, AccountGeneratorState>(
        builder: (context, state) {
      final generator = context.read<AccountGeneratorCubit>();
      if (state.status.isSubmissionInProgress) {
        return const CircularProgressIndicator();
      } else {
        return Wrap(
          children: [
            Text(state.account.address).center(),
            ElevatedButton(
                    onPressed: () => generator.generate(),
                    child: const Text('生成'))
                .center(),
            if (!state.account.isEmpty)
              ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(state.account),
                      child: const Text('就这个了'))
                  .center()
          ],
        );
      }
    });
  }
}
