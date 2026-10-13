# Contributing to NaviHer AI

Thank you for your interest in contributing to NaviHer AI! We welcome contributions to help improve safety-centric navigation and geospatial algorithms.

## Code of Conduct

Please be respectful, collaborative, and constructive when opening issues, reviewing pull requests, or participating in discussions.

## Getting Started

1. **Fork the repository** on GitHub.
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/<your-username>/NaviHer.git
   cd NaviHer
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Create a topic branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

### Running the App
- **Local Prototype Mode (No setup required)**:
  ```bash
  flutter run
  ```
- **Supabase Backend Mode**:
  ```bash
  cp .env.example .env
  # Update .env with your credentials and set USE_SUPABASE=true
  ./run_supabase.sh
  ```

### Code Style & Quality Checks
Before submitting a pull request, ensure:
1. **Static Analysis Passes**:
   ```bash
   flutter analyze
   ```
2. **All Tests Pass**:
   ```bash
   flutter test
   ```
3. **Code Formatting**:
   ```bash
   dart format lib/ test/
   ```

## Pull Request Guidelines

- Provide a concise description of the change, why it was made, and any visual or behavioral impacts.
- For UI changes, attach before/after screenshots or screen recordings where applicable.
- Ensure all automated checks pass.
