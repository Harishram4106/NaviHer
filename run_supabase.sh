#!/bin/bash
# Run NaviHer with Supabase environment variables loaded from .env

if [ -f .env ]; then
  flutter run --dart-define-from-file=.env
else
  echo ".env file not found. Please create one with SUPABASE_URL and SUPABASE_ANON_KEY."
  flutter run
fi
