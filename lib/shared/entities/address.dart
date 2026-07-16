// Shared entity: Address is used across features (users, sales/checkout).
// The canonical definition lives in users/domain/entities/address.dart.
// Import from this file to decouple cross-feature consumers from the users feature.
export 'package:harvest_app/features/users/domain/entities/address.dart';
