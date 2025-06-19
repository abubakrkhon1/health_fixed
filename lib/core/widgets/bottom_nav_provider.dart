import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavProvider = StateProvider<int>((ref)=>0);

class BottomNav {
  final int index;

  BottomNav({
    required this.index,
  });
}