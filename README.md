# harvest_app

A new Flutter project.

Create env folder in root directory

- dev.json
- stag.json
- prod.json

{
"BASE_URL": "https://your-base-url.com"
}

then launch with `flutter run --dart-define-from-file=env/dev.json

flutter run -d chrome --web-browser-flag "--disable-web-security" --dart-define-from-file=env/prod.json