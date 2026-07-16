// shared/ — cross-feature reusable pieces that don't belong to a single feature.
//
// Structure:
//   shared/
//     entities/   — domain entities used by 2+ features (Address, UserProfile)
//     widgets/    — UI components used by 2+ features (barrel → core/widgets/)
//     extensions/ — Dart extensions used app-wide
//
// Rule of thumb:
//   • If only ONE feature uses it → keep it inside that feature.
//   • If MULTIPLE features use it → move it here.
//   • If it's infrastructure (HTTP, DB, error handling) → it belongs in core/.
//
// What intentionally stays in core/ (not shared/):
//   • PaginatedResponse — infrastructure-level pagination model
//   • Error types (Failure, Exception) — domain infrastructure
//   • Services (Dio, DB) — technical infrastructure
