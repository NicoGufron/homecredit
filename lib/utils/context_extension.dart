import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Buat dijadiin extension langsung tanpa harus tulis AppLocalizations.of(context)!
extension BuildContextExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;  
}