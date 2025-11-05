# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StringUtils do
  describe '.my_reverse' do
    context 'with valid string inputs' do
      it 'reverses a simple string' do
        expect(described_class.my_reverse('abc')).to eq('cba')
      end

      it 'reverses a single character string' do
        expect(described_class.my_reverse('a')).to eq('a')
      end

      it 'returns empty string for empty input' do
        expect(described_class.my_reverse('')).to eq('')
      end

      it 'reverses a string with spaces' do
        expect(described_class.my_reverse('hello world')).to eq('dlrow olleh')
      end

      it 'reverses a string with special characters' do
        expect(described_class.my_reverse('hello@123')).to eq('321@olleh')
      end

      it 'reverses a string with punctuation' do
        expect(described_class.my_reverse('Hello, World!')).to eq('!dlroW ,olleH')
      end

      it 'reverses a string with numbers' do
        expect(described_class.my_reverse('12345')).to eq('54321')
      end

      it 'reverses a palindrome' do
        expect(described_class.my_reverse('racecar')).to eq('racecar')
      end
    end

    context 'with unicode and multibyte characters' do
      it 'handles basic unicode characters' do
        expect(described_class.my_reverse('åßç')).to eq('çßå')
      end

      it 'handles emoji characters' do
        expect(described_class.my_reverse('Hello😀World')).to eq('dlroW😀olleH')
      end

      it 'handles Japanese characters' do
        expect(described_class.my_reverse('こんにちは')).to eq('はちにんこ')
      end

      it 'handles Arabic characters' do
        expect(described_class.my_reverse('مرحبا')).to eq('ابحرم')
      end

      it 'handles mixed unicode and ASCII' do
        expect(described_class.my_reverse('Café')).to eq('éfaC')
      end
    end

    context 'with whitespace variations' do
      it 'reverses string with leading spaces' do
        expect(described_class.my_reverse('  abc')).to eq('cba  ')
      end

      it 'reverses string with trailing spaces' do
        expect(described_class.my_reverse('abc  ')).to eq('  cba')
      end

      it 'reverses string with tabs' do
        expect(described_class.my_reverse("hello\tworld")).to eq("dlrow\tolleh")
      end

      it 'reverses string with newlines' do
        expect(described_class.my_reverse("hello\nworld")).to eq("dlrow\nolleh")
      end

      it 'reverses string with multiple whitespace types' do
        expect(described_class.my_reverse("a\t b\n c")).to eq("c \nb \ta")
      end
    end

    context 'with long strings' do
      it 'reverses a long string efficiently' do
        input = 'a' * 1000
        expected = 'a' * 1000
        expect(described_class.my_reverse(input)).to eq(expected)
      end

      it 'reverses a long varied string' do
        input = 'abcdefghij' * 100
        expected = ('abcdefghij' * 100).reverse
        expect(described_class.my_reverse(input)).to eq(expected)
      end
    end

    context 'with invalid inputs' do
      it 'raises ArgumentError for nil input' do
        expect { described_class.my_reverse(nil) }.to raise_error(ArgumentError, 'Expected a String')
      end

      it 'raises ArgumentError for integer input' do
        expect { described_class.my_reverse(123) }.to raise_error(ArgumentError, 'Expected a String')
      end

      it 'raises ArgumentError for float input' do
        expect { described_class.my_reverse(12.34) }.to raise_error(ArgumentError, 'Expected a String')
      end

      it 'raises ArgumentError for array input' do
        expect { described_class.my_reverse(['a', 'b']) }.to raise_error(ArgumentError, 'Expected a String')
      end

      it 'raises ArgumentError for hash input' do
        expect { described_class.my_reverse({ key: 'value' }) }.to raise_error(ArgumentError, 'Expected a String')
      end

      it 'raises ArgumentError for boolean input' do
        expect { described_class.my_reverse(true) }.to raise_error(ArgumentError, 'Expected a String')
      end

      it 'raises ArgumentError for symbol input' do
        expect { described_class.my_reverse(:symbol) }.to raise_error(ArgumentError, 'Expected a String')
      end
    end

    context 'with edge cases' do
      it 'does not mutate the original string' do
        original = 'hello'
        described_class.my_reverse(original)
        expect(original).to eq('hello')
      end

      it 'returns a new string object' do
        original = 'hello'
        result = described_class.my_reverse(original)
        expect(result.object_id).not_to eq(original.object_id)
      end

      it 'handles frozen strings' do
        frozen_str = 'hello'.freeze
        expect { described_class.my_reverse(frozen_str) }.not_to raise_error
        expect(described_class.my_reverse(frozen_str)).to eq('olleh')
      end

      it 'reverses string with repeated characters' do
        expect(described_class.my_reverse('aaabbbccc')).to eq('cccbbbaaa')
      end

      it 'reverses string with escape sequences' do
        expect(described_class.my_reverse('hello\\nworld')).to eq('dlrown\\olleh')
      end
    end

    context 'with performance characteristics' do
      it 'completes in reasonable time for medium strings' do
        input = 'x' * 10_000
        start_time = Time.now
        result = described_class.my_reverse(input)
        elapsed_time = Time.now - start_time

        expect(result.length).to eq(10_000)
        expect(elapsed_time).to be < 0.1
      end
    end
  end
end
