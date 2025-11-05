# frozen_string_literal: true

require 'benchmark'
require_relative '../lib/string_utils'

puts '=' * 80
puts 'StringUtils.my_reverse Performance Benchmarking'
puts '=' * 80
puts

sizes = [10, 100, 1_000, 10_000, 100_000, 1_000_000]

puts 'Testing with repeated character strings (worst case for some algorithms):'
puts '-' * 80
sizes.each do |n|
  input = 'a' * n
  time = Benchmark.realtime { StringUtils.my_reverse(input) }
  puts format('Size: %10d chars | Time: %10.6f seconds | Rate: %12.0f chars/sec',
              n, time, n / time)
end

puts
puts 'Testing with varied character strings:'
puts '-' * 80
sizes.each do |n|
  input = ('abcdefghij' * (n / 10 + 1))[0...n]
  time = Benchmark.realtime { StringUtils.my_reverse(input) }
  puts format('Size: %10d chars | Time: %10.6f seconds | Rate: %12.0f chars/sec',
              n, time, n / time)
end

puts
puts 'Testing with unicode characters:'
puts '-' * 80
[10, 100, 1_000, 10_000].each do |n|
  input = ('こんにちは世界' * (n / 7 + 1))[0...n]
  time = Benchmark.realtime { StringUtils.my_reverse(input) }
  puts format('Size: %10d chars | Time: %10.6f seconds | Rate: %12.0f chars/sec',
              n, time, n / time)
end

puts
puts 'Memory allocation test (10 iterations):'
puts '-' * 80
[1_000, 10_000, 100_000].each do |n|
  input = 'x' * n
  result = Benchmark.measure do
    10.times { StringUtils.my_reverse(input) }
  end
  puts format('Size: %10d chars | Total time: %8.6f sec | Avg: %8.6f sec',
              n, result.real, result.real / 10)
end

puts
puts 'Complexity validation (should scale linearly O(n)):'
puts '-' * 80
baseline_size = 1_000
baseline_time = Benchmark.realtime { StringUtils.my_reverse('a' * baseline_size) }

[10_000, 100_000, 1_000_000].each do |n|
  time = Benchmark.realtime { StringUtils.my_reverse('a' * n) }
  expected_time = baseline_time * (n.to_f / baseline_size)
  ratio = time / expected_time
  status = ratio < 2.0 ? 'PASS' : 'WARN'

  puts format('Size: %10d | Time: %8.6f | Expected: %8.6f | Ratio: %5.2fx [%s]',
              n, time, expected_time, ratio, status)
end

puts
puts '=' * 80
puts 'Benchmark Complete'
puts '=' * 80
