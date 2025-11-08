# frozen_string_literal: true

require 'spec_helper'
require 'benchmark'

RSpec.describe ArrayUtils do
  describe '.my_max' do
    context 'with simple arrays' do
      it 'finds max in single element array' do
        expect(described_class.my_max([5])).to eq(5)
      end

      it 'finds max in flat array of positive integers' do
        expect(described_class.my_max([1, 2, 3, 4, 5])).to eq(5)
      end

      it 'finds max in unordered array' do
        expect(described_class.my_max([3, 1, 4, 1, 5, 9, 2, 6])).to eq(9)
      end

      it 'finds max when it is the first element' do
        expect(described_class.my_max([10, 1, 2, 3])).to eq(10)
      end

      it 'finds max when it is the last element' do
        expect(described_class.my_max([1, 2, 3, 10])).to eq(10)
      end

      it 'finds max in array with duplicate values' do
        expect(described_class.my_max([5, 5, 5])).to eq(5)
      end
    end

    context 'with nested arrays' do
      it 'finds max in simple nested array' do
        expect(described_class.my_max([1, [2, 3]])).to eq(3)
      end

      it 'finds max in deeply nested array' do
        expect(described_class.my_max([1, [2, [3, [4, [5]]]]])).to eq(5)
      end

      it 'finds max in nested array at start' do
        expect(described_class.my_max([[10, 5], 1, 2])).to eq(10)
      end

      it 'finds max in nested array at end' do
        expect(described_class.my_max([1, 2, [5, 10]])).to eq(10)
      end

      it 'finds max in multiple nested arrays' do
        expect(described_class.my_max([[1, 2], [3, 4], [5, 6]])).to eq(6)
      end

      it 'finds max in complex nested structure' do
        expect(described_class.my_max([1, [2, [3, 4], 5], [6, 7], 8])).to eq(8)
      end

      it 'finds max in nested array with single elements' do
        expect(described_class.my_max([[[[[1]]]]])).to eq(1)
      end
    end

    context 'with negative numbers' do
      it 'finds max in array of negative numbers' do
        expect(described_class.my_max([-5, -3, -10, -1])).to eq(-1)
      end

      it 'finds max in mixed positive and negative numbers' do
        expect(described_class.my_max([-5, 10, -3, 7])).to eq(10)
      end

      it 'finds max in nested array with negative numbers' do
        expect(described_class.my_max([[-10, -5], [-3, -1]])).to eq(-1)
      end

      it 'finds max when zero is the maximum' do
        expect(described_class.my_max([-5, -3, 0, -10])).to eq(0)
      end

      it 'finds max in deeply nested negative numbers' do
        expect(described_class.my_max([[-1, [-2, [-3, [-4]]]], -5])).to eq(-1)
      end
    end

    context 'with large numbers' do
      it 'handles very large integers' do
        expect(described_class.my_max([1_000_000, 999_999])).to eq(1_000_000)
      end

      it 'handles very large negative integers' do
        expect(described_class.my_max([-1_000_000, -999_999])).to eq(-999_999)
      end

      it 'handles nested arrays with large numbers' do
        expect(described_class.my_max([[1_000_000], [999_999, [1_000_001]]])).to eq(1_000_001)
      end
    end

    context 'with invalid inputs' do
      it 'raises ArgumentError for nil input' do
        expect { described_class.my_max(nil) }.to raise_error(ArgumentError, 'Expected an Array')
      end

      it 'raises ArgumentError for string input' do
        expect { described_class.my_max('string') }.to raise_error(ArgumentError, 'Expected an Array')
      end

      it 'raises ArgumentError for integer input' do
        expect { described_class.my_max(123) }.to raise_error(ArgumentError, 'Expected an Array')
      end

      it 'raises ArgumentError for hash input' do
        expect { described_class.my_max({ key: 'value' }) }.to raise_error(ArgumentError, 'Expected an Array')
      end

      it 'raises ArgumentError for array containing string' do
        expect { described_class.my_max([1, 'two', 3]) }
          .to raise_error(ArgumentError, 'Array contains non-integer, non-array element')
      end

      it 'raises ArgumentError for array containing nil' do
        expect { described_class.my_max([1, nil, 3]) }
          .to raise_error(ArgumentError, 'Array contains non-integer, non-array element')
      end

      it 'raises ArgumentError for array containing float' do
        expect { described_class.my_max([1, 2.5, 3]) }
          .to raise_error(ArgumentError, 'Array contains non-integer, non-array element')
      end

      it 'raises ArgumentError for nested array containing string' do
        expect { described_class.my_max([1, [2, 'three']]) }
          .to raise_error(ArgumentError, 'Array contains non-integer, non-array element')
      end
    end

    context 'with edge cases' do
      it 'handles array with single nested empty level' do
        expect(described_class.my_max([[1, 2]])).to eq(2)
      end

      it 'handles alternating positive and negative numbers' do
        expect(described_class.my_max([-1, 1, -2, 2, -3, 3])).to eq(3)
      end

      it 'handles deeply nested structure with max at deepest level' do
        expect(described_class.my_max([1, [2, [3, [4, [5, [6, [7, [8, [9, [10]]]]]]]]]])).to eq(10)
      end

      it 'handles wide nested structure' do
        expect(described_class.my_max([[1], [2], [3], [4], [5]])).to eq(5)
      end

      it 'handles mixed nesting depths' do
        expect(described_class.my_max([1, [2], [[3]], [[[4]]], [[[[5]]]]])).to eq(5)
      end
    end

    context 'with performance characteristics' do
      it 'completes in reasonable time for large flat arrays' do
        input = Array.new(10_000) { |i| i }
        elapsed_time = Benchmark.realtime { described_class.my_max(input) }
        result = described_class.my_max(input)

        expect(result).to eq(9_999)
        expect(elapsed_time).to be < 0.1
      end

      it 'completes in reasonable time for deeply nested arrays' do
        input = [1]
        100.times { input = [input] }

        elapsed_time = Benchmark.realtime { described_class.my_max(input) }
        result = described_class.my_max(input)

        expect(result).to eq(1)
        expect(elapsed_time).to be < 0.1
      end
    end
  end
end
