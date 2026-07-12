import 'package:flutter_riverpod/flutter_riverpod.dart';

// Default role is consumer.
// Other options: 'PRODUCER'
final authRoleProvider = StateProvider<String>((ref) => 'CONSUMER');
