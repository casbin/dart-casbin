# Contributing to dart-casbin

Thank you for your interest in contributing to dart-casbin! This document provides guidelines and instructions for contributing.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and collaborative environment.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue on GitHub with:
- A clear, descriptive title
- Steps to reproduce the issue
- Expected behavior vs actual behavior
- Your environment (Dart version, OS, etc.)
- Any relevant code samples or error messages

### Suggesting Enhancements

Enhancement suggestions are welcome! Please create an issue with:
- A clear description of the enhancement
- Use cases and benefits
- Any implementation ideas you may have

### Pull Requests

1. **Fork the repository** and create your branch from `master`
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write clear, self-documenting code
   - Follow the existing code style
   - Add tests for new functionality
   - Update documentation as needed

3. **Test your changes**
   ```bash
   dart pub get
   dart format .
   dart test
   ```

4. **Commit your changes**
   - Use clear, descriptive commit messages
   - Follow [Conventional Commits](https://www.conventionalcommits.org/) format:
     - `feat:` for new features
     - `fix:` for bug fixes
     - `docs:` for documentation changes
     - `refactor:` for code refactoring
     - `test:` for test changes
     - `chore:` for maintenance tasks

5. **Push to your fork** and submit a pull request
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Wait for review** - A maintainer will review your PR and may request changes

## Development Setup

1. **Install Dart SDK**: Follow the [official Dart installation guide](https://dart.dev/get-dart)

2. **Clone the repository**
   ```bash
   git clone https://github.com/casbin/dart-casbin.git
   cd dart-casbin
   ```

3. **Install dependencies**
   ```bash
   dart pub get
   ```

4. **Run tests**
   ```bash
   dart test
   ```

5. **Check formatting**
   ```bash
   dart format --output=none --set-exit-if-changed .
   ```

## Code Style

- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide
- Use `dart format` to format your code
- Use relative imports for internal packages
- Add appropriate comments for complex logic
- Maintain consistency with existing code

## Testing

- Write tests for all new functionality
- Ensure all tests pass before submitting a PR
- Aim for high test coverage
- Tests should be clear and maintainable

## Documentation

- Update the README.md if you change functionality
- Add dartdoc comments for public APIs
- Include code examples in documentation where helpful
- Keep the CHANGELOG.md updated (this is done automatically via semantic-release)

## Questions?

If you have questions, feel free to:
- Open an issue on GitHub
- Join our [Discord community](https://discord.gg/S5UjpzGZjN)
- Contact the maintainers at hsluoyz@gmail.com

## License

By contributing, you agree that your contributions will be licensed under the Apache 2.0 License.
