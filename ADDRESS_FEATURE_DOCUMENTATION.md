# Address Management Feature - Complete Implementation

## Overview

A complete address management system for an e-commerce mobile app built with Flutter, following Clean Architecture principles and using Riverpod for state management. The implementation includes full CRUD functionality with local JSON simulation.

## Architecture

### Clean Architecture Layers

#### 1. **Domain Layer** (`lib/domain/`)

Contains business logic and entities independent of external dependencies.

**Entities:**

- `Address` - Core address entity with all required fields (location, recipient, contact info)

**Use Cases:**

- `GetAddressesUseCase` - Fetch all user addresses
- `AddAddressUseCase` - Create a new address
- `UpdateAddressUseCase` - Modify existing address
- `DeleteAddressUseCase` - Remove an address
- `SetPrimaryAddressUseCase` - Mark an address as primary

**Repository Interface:**

- `AddressRepository` - Abstract contract for data operations

#### 2. **Data Layer** (`lib/data/`)

Handles data sources and repository implementations.

**Models:**

- `AddressModel` - JSON serializable model with `toEntity()` conversion

**Data Sources:**

- `AddressLocalDataSource` - Simulates API responses with in-memory storage
  - Mock data: 2 initial addresses (Home in Menteng, Office in Setiabudi)
  - Simulated network delays (500-800ms)
  - Auto-incrementing IDs
  - Primary address validation

**Repository Implementation:**

- `AddressRepositoryImpl` - Connects use cases to local data source

#### 3. **Presentation Layer** (`lib/presentation/`)

UI components and state management.

**Providers** (`providers/address_providers.dart`):

- `addressLocalDataSourceProvider` - Data source instance
- `addressRepositoryProvider` - Repository instance
- `getAddressesUseCaseProvider` - Fetch use case
- `addAddressUseCaseProvider` - Add use case
- `updateAddressUseCaseProvider` - Update use case
- `deleteAddressUseCaseProvider` - Delete use case
- `setPrimaryAddressUseCaseProvider` - Set primary use case
- `addressesProvider` - FutureProvider for address list state

**Screens:**

1. **AddressesScreen** (`screens/addresses_screen.dart`)

   - Lists all saved addresses
   - Shows primary address badge
   - Empty state with CTA
   - Tap address to show options (edit, delete, set primary)
   - FAB to add new address

2. **AddEditAddressScreen** (`screens/add_edit_address_screen.dart`)
   - Form for adding/editing addresses
   - Fields: label, recipient name, phone, full address, province, city, district, subdistrict, postal code, notes
   - Province/City/District selectors (bottom sheet UI ready)
   - Location picker placeholder
   - Form validation
   - Loading states
   - Success/error feedback

## Features

### ✅ Implemented Features

1. **View All Addresses**

   - Displays addresses in card format
   - Shows label, recipient info, full address
   - Primary address indicator
   - Notes section with info icon
   - Empty state when no addresses

2. **Add New Address**

   - Navigate to form screen
   - Input all required fields
   - Auto-set first address as primary
   - Save to local storage
   - Refresh list on success

3. **Edit Address**

   - Pre-fill form with existing data
   - Update all fields
   - Preserve creation date
   - Update timestamp on save

4. **Delete Address**

   - Confirmation dialog
   - Prevent deletion of primary address
   - Remove from list
   - Show success message

5. **Set Primary Address**
   - One-tap to set primary
   - Auto-unset previous primary
   - Visual feedback
   - Instant list update

### Data Simulation

**Mock Addresses:**

```json
{
  "addr_1": {
    "label": "Home",
    "recipientName": "John Doe",
    "phone": "+62 812-3456-7890",
    "fullAddress": "Jl. Merdeka No. 123",
    "province": "DKI Jakarta",
    "city": "Jakarta Pusat",
    "district": "Menteng",
    "isPrimary": true
  },
  "addr_2": {
    "label": "Office",
    "recipientName": "John Doe",
    "phone": "+62 812-3456-7890",
    "fullAddress": "Jl. Sudirman No. 456, Lt. 5",
    "province": "DKI Jakarta",
    "city": "Jakarta Selatan",
    "district": "Setiabudi",
    "isPrimary": false
  }
}
```

**API Simulation:**

- `GET /api/v1/addresses` - 500ms delay
- `POST /api/v1/addresses` - 800ms delay
- `PUT /api/v1/addresses/:id` - 800ms delay
- `DELETE /api/v1/addresses/:id` - 600ms delay
- `PUT /api/v1/addresses/:id/primary` - 600ms delay

## Design System

**Colors:**

- Background: `#FAFAF8` (kBgColor)
- Primary Dark: `#1A2F25` (kDarkGreen)
- Accent: `#E86A33` (kAccentOrange)
- Pill/Card: `#F0F2F0` (kPillGrey)
- Text Secondary: `#6E7A75` (kTextGrey)

**Typography:**

- Headings: Playfair Display (serif)
- Body: DM Sans (sans-serif)

**Components:**

- Rounded cards (20px radius)
- Pill badges for labels
- Icon containers with background
- Bottom sheets for options
- Material dialogs for confirmations

## File Structure

```
lib/
├── data/
│   ├── datasources/
│   │   └── address_local_datasource.dart
│   ├── models/
│   │   └── address_model.dart
│   └── repositories/
│       └── address_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── address.dart
│   ├── repositories/
│   │   └── address_repository.dart
│   └── usecases/
│       ├── add_address_usecase.dart
│       ├── delete_address_usecase.dart
│       ├── get_addresses_usecase.dart
│       ├── set_primary_address_usecase.dart
│       └── update_address_usecase.dart
└── presentation/
    ├── features/
    │   └── addresses/
    │       └── screens/
    │           ├── add_edit_address_screen.dart
    │           └── addresses_screen.dart
    └── providers/
        └── address_providers.dart
```

## Usage Example

```dart
// Navigate to addresses screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const AddressesScreen()),
);

// Access addresses in any widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressesProvider);

    return addressesAsync.when(
      data: (addresses) => ListView(children: [...]),
      loading: () => CircularProgressIndicator(),
      error: (error, _) => Text('Error: $error'),
    );
  }
}
```

## Future Enhancements

1. **Location Services Integration:**

   - Google Maps integration for location picker
   - Province/City/District API endpoints
   - Geocoding and reverse geocoding
   - Current location detection

2. **Advanced Features:**

   - Address search/filter
   - Address categories (home, work, other)
   - Delivery instructions
   - Address verification status
   - Multiple phone numbers
   - Favorite addresses

3. **Backend Integration:**
   - Replace local datasource with API client
   - User authentication
   - Cloud synchronization
   - Offline support with local cache

## Testing

All core functionality is working:

- ✅ List addresses
- ✅ Add new address
- ✅ Edit existing address
- ✅ Delete address (with protection)
- ✅ Set primary address
- ✅ Form validation
- ✅ Loading states
- ✅ Error handling
- ✅ Navigation flows

## Dependencies

- `flutter_riverpod` - State management
- `dartz` - Functional programming (Either type)
- `google_fonts` - Typography (Playfair Display, DM Sans)
- `equatable` - Entity equality
- `json_annotation` - JSON serialization

---

**Built with Clean Architecture + Riverpod + Local JSON Simulation**
