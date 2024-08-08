import 'package:riverpod/riverpod.dart';

final showEmailForm = StateProvider<bool>(
  (ref) {
    return false;
  },
);

final showRegisterForm = StateProvider<bool>(
  (ref) {
    return false;
  },
);

final recordedNoteChosen = StateProvider<bool>(
  (ref) {
    return false;
  },
);
