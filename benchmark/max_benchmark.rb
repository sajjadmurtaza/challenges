# frozen_string_literal: true

require 'benchmark'
require_relative '../lib/array_utils'

puts '=' * 80
puts 'ArrayUtils.my_max Performance Benchmarking'
puts '=' * 80
puts

sizes = [10, 100, 1_000, 10_000, 100_000]

puts 'Testing with flat arrays (best case):'
puts '-' * 80
sizes.each do |n|
  input = Array.new(n) { |i| i }
  time = Benchmark.realtime { ArrayUtils.my_max(input) }
  puts format('Size: %<size>10d elements | Time: %<time>10.6f seconds | Rate: %<rate>12.0f elements/sec',
              size: n, time: time, rate: n / time)
end

puts
puts 'Testing with single-level nested arrays:'
puts '-' * 80
sizes.each do |n|
  input = Array.new(n) { |i| [i] }
  time = Benchmark.realtime { ArrayUtils.my_max(input) }
  puts format('Size: %<size>10d elements | Time: %<time>10.6f seconds | Rate: %<rate>12.0f elements/sec',
              size: n, time: time, rate: n / time)
end

puts
puts 'Testing with deeply nested arrays:'
puts '-' * 80
[10, 50, 100, 500, 1_000].each do |depth|
  input = [1]
  (depth - 1).times { input = [input] }
  time = Benchmark.realtime { ArrayUtils.my_max(input) }
  puts format('Depth: %<depth>10d levels | Time: %<time>10.6f seconds',
              depth: depth, time: time)
end

puts
puts 'Testing with mixed nested structures:'
puts '-' * 80
sizes.each do |n|
  input = []
  n.times { |i| input << (i.even? ? i : [i]) }
  time = Benchmark.realtime { ArrayUtils.my_max(input) }
  puts format('Size: %<size>10d elements | Time: %<time>10.6f seconds | Rate: %<rate>12.0f elements/sec',
              size: n, time: time, rate: n / time)
end

puts
puts 'Testing with negative number arrays:'
puts '-' * 80
[100, 1_000, 10_000, 100_000].each do |n|
  input = Array.new(n, &:-@)
  time = Benchmark.realtime { ArrayUtils.my_max(input) }
  puts format('Size: %<size>10d elements | Time: %<time>10.6f seconds | Rate: %<rate>12.0f elements/sec',
              size: n, time: time, rate: n / time)
end

puts
puts 'Memory allocation test (10 iterations):'
puts '-' * 80
[1_000, 10_000, 100_000].each do |n|
  input = Array.new(n) { |i| i }
  result = Benchmark.measure do
    10.times { ArrayUtils.my_max(input) }
  end
  puts format('Size: %<size>10d elements | Total time: %<total>8.6f sec | Avg: %<avg>8.6f sec',
              size: n, total: result.real, avg: result.real / 10)
end

puts
puts 'Complexity validation (should scale linearly O(n)):'
puts '-' * 80
baseline_size = 1_000
baseline_input = Array.new(baseline_size) { |i| i }
baseline_time = Benchmark.realtime { ArrayUtils.my_max(baseline_input) }

[10_000, 100_000, 1_000_000].each do |n|
  input = Array.new(n) { |i| i }
  time = Benchmark.realtime { ArrayUtils.my_max(input) }
  expected_time = baseline_time * (n.to_f / baseline_size)
  ratio = time / expected_time
  status = ratio < 2.0 ? 'PASS' : 'WARN'

  puts format('Size: %<size>10d | Time: %<time>8.6f | Expected: %<expected>8.6f | ' \
              'Ratio: %<ratio>5.2fx [%<status>s]',
              size: n, time: time, expected: expected_time, ratio: ratio, status: status)
end

puts
puts '=' * 80
puts 'Benchmark Complete'
puts '=' * 80
