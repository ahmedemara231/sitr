import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/delete_account.dart';
import 'delete_account/delete_account_reason_sheet_body.dart';

class DeleteAccountReasonSheet extends StatelessWidget {
  final FutureOr<void> Function(String msg) onSuccess;

  const DeleteAccountReasonSheet({
    required this.onSuccess,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DeleteAccountReasonsCubit()..getReasons(),
        ),
        BlocProvider(create: (context) => DeleteAccountCubit()),
      ],
      child: DeleteAccountReasonSheetBody(onSuccess: onSuccess),
    );
  }
}
