# Ruby Coding Challenges

Production-ready Ruby utilities demonstrating professional development practices through algorithmic challenges.

## Overview

A collection of custom algorithm implementations built to showcase professional software development practices including comprehensive testing, performance benchmarking, code quality enforcement, and automated CI/CD.

## Challenges

### Challenge 1: String Reversal

Custom string reversal implementation without using Ruby's built-in `reverse` or `reverse!` methods.

**Features:**
- O(n) time complexity implementation
- Type safety with input validation
- Unicode support for multibyte characters
- 33 comprehensive test cases with 100% coverage

### Challenge 2: Nested Array Maximum

Find the maximum value in nested array structures without using array flattening methods.

**Features:**
- Recursive traversal of nested arrays
- O(n) time complexity for total elements
- Handles negative numbers and deep nesting
- 36 comprehensive test cases with full validation

## Project Features

- **100% Test Coverage**: 69 total test cases across all challenges
- **Performance Validated**: Comprehensive benchmarking for all implementations
- **Code Quality**: RuboCop linting with Ruby 3.4 standards
- **CI/CD Pipeline**: Automated testing, linting, and benchmarking
- **Professional Structure**: Clean separation of concerns and documentation

## Installation

Clone the repository:

```bash
git clone https://github.com/sajjadmurtaza/challenges.git
cd challenges
```

Install dependencies:

```bash
bundle install
```

## Usage

### String Reversal (Challenge 1)

#### Basic Usage

```ruby
require_relative 'lib/string_utils'

StringUtils.my_reverse('hello')
# => "olleh"

StringUtils.my_reverse('Hello, World!')
# => "!dlroW ,olleH"

StringUtils.my_reverse('12345')
# => "54321"
```

#### Unicode Support

```ruby
StringUtils.my_reverse('Café')
# => "éfaC"

StringUtils.my_reverse('こんにちは')
# => "はちにんこ"

StringUtils.my_reverse('Hello😀World')
# => "dlroW😀olleH"
```

#### Error Handling

```ruby
StringUtils.my_reverse(nil)
# => ArgumentError: Expected a String

StringUtils.my_reverse(123)
# => ArgumentError: Expected a String
```

### Nested Array Maximum (Challenge 2)

#### Basic Usage

```ruby
require_relative 'lib/array_utils'

ArrayUtils.my_max([1, 2, 3, 4, 5])
# => 5

ArrayUtils.my_max([1, [2, 3]])
# => 3

ArrayUtils.my_max([1, [2, [3, [4, [5]]]]])
# => 5
```

#### Negative Numbers

```ruby
ArrayUtils.my_max([-5, -3, -10, -1])
# => -1

ArrayUtils.my_max([-5, 10, -3, 7])
# => 10

ArrayUtils.my_max([[-10, -5], [-3, -1]])
# => -1
```

#### Complex Nesting

```ruby
ArrayUtils.my_max([[1, 2], [3, 4], [5, 6]])
# => 6

ArrayUtils.my_max([1, [2, [3, 4], 5], [6, 7], 8])
# => 8
```

#### Error Handling

```ruby
ArrayUtils.my_max(nil)
# => ArgumentError: Expected an Array

ArrayUtils.my_max([1, 'two', 3])
# => ArgumentError: Array contains non-integer, non-array element
```

#### Edge Cases

```ruby
ArrayUtils.my_max([])
# => nil (empty array returns nil)

ArrayUtils.my_max([[]])
# => nil (nested empty arrays return nil)
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

Run specific challenge tests:

```bash
bundle exec rspec spec/string_utils_spec.rb
bundle exec rspec spec/array_utils_spec.rb
```

### Test Coverage

The project maintains 100% line coverage:

- **String Reversal**: 33 test cases
  - Valid string inputs (8 tests)
  - Unicode and multibyte characters (5 tests)
  - Whitespace variations (5 tests)
  - Invalid input validation (7 tests)
  - Edge cases (5 tests)
  - Long string handling (2 tests)
  - Performance characteristics (1 test)

- **Nested Array Maximum**: 36 test cases
  - Simple arrays (6 tests)
  - Nested arrays (7 tests)
  - Negative numbers (5 tests)
  - Large numbers (3 tests)
  - Invalid inputs (8 tests)
  - Edge cases (5 tests)
  - Performance characteristics (2 tests)

View coverage report:

```bash
open coverage/index.html
```

## Performance Benchmarking

Run comprehensive performance benchmarks:

```bash
ruby benchmark/reverse_benchmark.rb
ruby benchmark/max_benchmark.rb
```

### String Reversal Performance

- Handles 1M characters in ~65ms
- Throughput: 2.5M - 15.4M chars/sec
- Confirms O(n) time complexity

### Array Maximum Performance

- Handles 1M elements in ~60ms
- Throughput: 6M - 15M elements/sec
- Efficient recursive traversal

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

- Ruby 3.4 compatibility
- Frozen string literals
- Single quote string style
- Max line length: 120 characters
- Consistent formatting

## CI/CD Pipeline

The project uses GitHub Actions for continuous integration:

### Automated Jobs

1. **Test Suite**: Runs on Ruby 3.4.x (tested with 3.4.7)
2. **RuboCop Linting**: Enforces code quality standards
3. **Performance Benchmarks**: Validates performance characteristics

All jobs run automatically on:
- Pushes to `main` branch
- Pull requests targeting `main`

## Technical Details

### String Reversal Algorithm

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

**Complexity:**
- Time: O(n) where n is string length
- Space: O(n) for the reversed string

### Array Maximum Algorithm

```ruby
def self.my_max(array)
  raise ArgumentError, 'Expected an Array' unless array.is_a?(Array)

  max_value = nil
  array.each do |element|
    if element.is_a?(Array)
      nested_max = my_max(element)
      max_value = nested_max if max_value.nil? || nested_max > max_value
    elsif element.is_a?(Integer)
      max_value = element if max_value.nil? || element > max_value
    else
      raise ArgumentError, 'Array contains non-integer, non-array element'
    end
  end
  max_value
end
```

**Complexity:**
- Time: O(n) where n is total number of elements
- Space: O(d) where d is maximum nesting depth

## Project Structure

```
challenges/
├── .github/
│   └── workflows/
│       └── ruby-ci.yml       # GitHub Actions CI/CD pipeline
├── benchmark/
│   ├── reverse_benchmark.rb  # String reversal benchmarks
│   └── max_benchmark.rb      # Array maximum benchmarks
├── coverage/                 # Test coverage reports (generated)
├── lib/
│   ├── string_utils.rb      # Challenge 1: String reversal
│   └── array_utils.rb       # Challenge 2: Nested array maximum
├── spec/
│   ├── spec_helper.rb       # RSpec configuration
│   ├── string_utils_spec.rb # String reversal tests (33 tests)
│   └── array_utils_spec.rb  # Array maximum tests (36 tests)
├── .gitignore               # Git ignore rules
├── .rspec                   # RSpec configuration
├── .rubocop.yml            # RuboCop linting rules
├── Gemfile                 # Dependency management
├── Rakefile                # Rake tasks
└── README.md               # This file
```

## Development

### Adding New Tests

Tests are located in `spec/`. Follow the existing patterns:

```ruby
it 'describes the expected behavior' do
  expect(Module.method('input')).to eq('expected')
end
```

### Running Individual Test Groups

```bash
bundle exec rspec spec/string_utils_spec.rb:10  # Run test at line 10
bundle exec rspec --tag focus                    # Run focused tests
```

## Requirements

- Ruby ~> 3.4.0 (tested with 3.4.7)
- Bundler >= 2.5

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
