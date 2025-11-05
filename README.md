# String Reversal Utils

Production-ready string manipulation utilities demonstrating professional Ruby development practices.

## Overview

A custom string reversal implementation built without using Ruby's built-in `reverse` or `reverse!` methods. This project showcases professional software development practices including comprehensive testing, performance benchmarking, code quality enforcement, and automated CI/CD.

## Features

- **Custom String Reversal**: O(n) time complexity implementation
- **Type Safety**: Input validation with clear error messages
- **Unicode Support**: Handles multibyte characters (emoji, Japanese, Arabic, etc.)
- **100% Test Coverage**: 33 comprehensive test cases
- **Performance Validated**: Benchmarked across multiple input sizes
- **Code Quality**: RuboCop linting with Ruby 3.0+ standards
- **CI/CD Pipeline**: Automated testing, linting, and benchmarking

## Installation

Clone the repository:

```bash
git clone https://github.com/sajjadmurtaza/string_reversal_utils.git
cd string_reversal_utils
```

Install dependencies:

```bash
bundle install
```

## Usage

### Basic Usage

```ruby
require_relative 'lib/string_utils'

StringUtils.my_reverse('hello')
# => "olleh"

StringUtils.my_reverse('Hello, World!')
# => "!dlroW ,olleH"

StringUtils.my_reverse('12345')
# => "54321"
```

### Unicode Support

```ruby
StringUtils.my_reverse('Café')
# => "éfaC"

StringUtils.my_reverse('こんにちは')
# => "はちにんこ"

StringUtils.my_reverse('Hello😀World')
# => "dlroW😀olleH"
```

### Error Handling

```ruby
StringUtils.my_reverse(nil)
# => ArgumentError: Expected a String

StringUtils.my_reverse(123)
# => ArgumentError: Expected a String
```

## Running Tests

Run the full test suite:

```bash
bundle exec rspec
```

Run tests with documentation format:

```bash
bundle exec rspec --format documentation
```

Run specific test file:

```bash
bundle exec rspec spec/string_utils_spec.rb
```

### Test Coverage

The project maintains 100% line coverage with 33 test cases covering:

- Valid string inputs (8 tests)
- Unicode and multibyte characters (5 tests)
- Whitespace variations (5 tests)
- Long string handling (2 tests)
- Invalid input validation (7 tests)
- Edge cases (5 tests)
- Performance characteristics (1 test)

View coverage report:

```bash
open coverage/index.html
```

## Performance Benchmarking

Run comprehensive performance benchmarks:

```bash
ruby benchmark/reverse_benchmark.rb
```

### Benchmark Categories

1. **Repeated Character Tests**: Validates worst-case scenarios
2. **Varied Character Tests**: Real-world mixed content
3. **Unicode Character Tests**: Multibyte character performance
4. **Memory Allocation Tests**: Multiple iteration efficiency
5. **Complexity Validation**: Confirms O(n) linear scaling

### Performance Results

- Handles 1M characters in ~65ms
- Throughput: 2.5M - 15.4M chars/sec
- Confirms O(n) time complexity
- No performance degradation over multiple runs

## Code Quality

### Linting

Run RuboCop to check code quality:

```bash
bundle exec rubocop
```

Auto-fix style violations:

```bash
bundle exec rubocop --auto-correct
```

### Code Style

- Ruby 3.0+ compatibility
- Frozen string literals
- Single quote string style
- Max line length: 120 characters
- Consistent formatting

## CI/CD Pipeline

The project uses GitHub Actions for continuous integration:

### Automated Jobs

1. **Test Suite**: Runs on Ruby 3.0, 3.1, 3.2, 3.3
2. **RuboCop Linting**: Enforces code quality standards
3. **Performance Benchmarks**: Validates performance characteristics

All jobs run automatically on:
- Pushes to `main` branch
- Pull requests targeting `main`

## Technical Details

### Algorithm

```ruby
def self.my_reverse(string)
  raise ArgumentError, 'Expected a String' unless string.is_a?(String)

  reversed = +''
  i = string.length - 1
  while i >= 0
    reversed << string[i]
    i -= 1
  end
  reversed
end
```

### Complexity Analysis

- **Time Complexity**: O(n) where n is string length
- **Space Complexity**: O(n) for the reversed string
- **Memory**: Uses `<<` operator for efficient string building
- **Performance**: Frozen string literals for optimization

### Design Decisions

1. **Character-by-character iteration**: Simple, predictable performance
2. **While loop**: Direct index access for clarity and KISS principle
3. **Type validation**: Fail fast with clear error messages
4. **Frozen string literals**: Memory optimization
5. **YARD documentation**: Clear method and module documentation

## Project Structure

```
string_reversal_utils/
├── .github/
│   └── workflows/
│       └── ruby-ci.yml       # GitHub Actions CI/CD pipeline
├── benchmark/
│   └── reverse_benchmark.rb  # Performance benchmarking suite
├── coverage/                 # Test coverage reports (generated)
├── lib/
│   └── string_utils.rb      # Core implementation
├── spec/
│   ├── spec_helper.rb       # RSpec configuration
│   └── string_utils_spec.rb # Test suite (33 tests)
├── .gitignore               # Git ignore rules
├── .rspec                   # RSpec configuration
├── .rubocop.yml            # RuboCop linting rules
├── Gemfile                 # Dependency management
├── Rakefile                # Rake tasks
└── README.md               # This file
```

## Development

### Adding New Tests

Tests are located in `spec/string_utils_spec.rb`. Follow the existing patterns:

```ruby
it 'describes the expected behavior' do
  expect(StringUtils.my_reverse('input')).to eq('expected')
end
```

### Running Individual Test Groups

```bash
bundle exec rspec spec/string_utils_spec.rb:10  # Run test at line 10
bundle exec rspec --tag focus                    # Run focused tests
```

## Requirements

- Ruby >= 3.0.0
- Bundler

### Dependencies

**Test Group**:
- rspec ~> 3.12
- simplecov ~> 0.22

**Development Group**:
- rake ~> 13.0
- rubocop ~> 1.50
- rubocop-rspec ~> 2.20

## Contributing

This project follows professional development practices:

1. Create feature branches from `main`
2. Write tests first (TDD approach)
3. Ensure 100% test coverage
4. Run RuboCop and fix violations
5. Create detailed pull requests
6. Use conventional commit messages (feat:, fix:, test:, docs:, etc.)

## License

This project is available for educational purposes.

## Contact

For questions or feedback, please open an issue on GitHub.
