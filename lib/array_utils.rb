# frozen_string_literal: true

module ArrayUtils
  # @param array [Array]
  # @return [Integer, nil] maximum value or nil if empty
  # @raise [ArgumentError] if not an Array or contains invalid elements
  def self.my_max(array)
    raise ArgumentError, 'Expected an Array' unless array.is_a?(Array)

    max_value = nil
    stack = [array]

    until stack.empty?
      stack.pop.each do |element|
        case element
        when Array
          stack.push(element)
        when Integer
          max_value = element if max_value.nil? || element > max_value
        else
          raise ArgumentError, 'Array contains non-integer, non-array element'
        end
      end
    end

    max_value
  end
end
