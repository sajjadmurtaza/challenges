# frozen_string_literal: true

require 'benchmark'
require_relative '../lib/array_utils'

def separator(title)
  puts '=' * 80
  puts title
  puts '=' * 80
  puts
end

def section(title)
  puts '-' * 80
  puts title
  puts '-' * 80
end

separator('ArrayUtils.my_max vs my_max_2 Performance Comparison')

# Test 1: Flat arrays (best case for both)
section('Test 1: Flat Arrays (No Nesting)')
[100, 1_000, 10_000, 100_000, 1_000_000].each do |size|
  arr = Array.new(size) { rand(-1000..1000) }

  Benchmark.bm(25) do |x|
    x.report("my_max (recursive): #{size}") { ArrayUtils.my_max(arr) }
    x.report("my_max_2 (iterative): #{size}") { ArrayUtils.my_max_2(arr) }
  end
  puts
end

# Test 2: Single-level nested arrays
section('Test 2: Single-Level Nested Arrays')
[100, 1_000, 10_000, 100_000].each do |size|
  arr = Array.new(size / 10) { Array.new(10) { rand(-1000..1000) } }

  Benchmark.bm(25) do |x|
    x.report("my_max (recursive): #{size}") { ArrayUtils.my_max(arr) }
    x.report("my_max_2 (iterative): #{size}") { ArrayUtils.my_max_2(arr) }
  end
  puts
end

# Test 3: Deep nesting (stress test)
section('Test 3: Deep Nesting')
[10, 50, 100, 500, 1000].each do |depth|
  arr = [1]
  depth.times { arr = [arr, 2] }

  Benchmark.bm(30) do |x|
    x.report("my_max (recursive): depth #{depth}") { ArrayUtils.my_max(arr) }
    x.report("my_max_2 (iterative): depth #{depth}") { ArrayUtils.my_max_2(arr) }
  end
  puts
end

# Test 4: Mixed nested structures
section('Test 4: Mixed Nested Structures')
[1_000, 10_000, 100_000].each do |size|
  arr = []
  (size / 100).times do
    arr << if rand < 0.3
             Array.new(rand(3..10)) { rand(-1000..1000) }
           else
             rand(-1000..1000)
           end
  end

  Benchmark.bm(25) do |x|
    x.report("my_max (recursive): #{size}") { ArrayUtils.my_max(arr) }
    x.report("my_max_2 (iterative): #{size}") { ArrayUtils.my_max_2(arr) }
  end
  puts
end

# Test 5: Multiple iterations for accuracy
section('Test 5: Multiple Iterations (Statistical Average)')
test_array = Array.new(10_000) { rand(-1000..1000) }
iterations = 100

puts "Running each method #{iterations} times on 10,000 element flat array..."
puts

Benchmark.bm(25) do |x|
  x.report('my_max (recursive)') do
    iterations.times { ArrayUtils.my_max(test_array) }
  end

  x.report('my_max_2 (iterative)') do
    iterations.times { ArrayUtils.my_max_2(test_array) }
  end
end

puts
separator('Comparison Complete')
puts
puts 'Analysis:'
puts '- Compare "user + system" time for total CPU usage'
puts '- Lower is better'
puts '- Real time includes I/O and system overhead'
puts
