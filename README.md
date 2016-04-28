Codecov for Dart
================
Just a simple Bash script to generate coverage reports for a Dart project and
upload them to Codecov. To use it, set the following environment variables:
- `DART_TESTS_MAIN` Relative tests entry file path
- `CODECOV_TOKEN` Codecov repository token

And run:
```
bash <(curl -s https://rawgit.com/hermanbergwerf/codecov-dart/upload.sh)
```
