# frozen_string_literal: true

module ArrayUtils
  # @param array [Array]
  # @return [Integer, nil] maximum value or nil if empty
  # @raise [ArgumentError] if not an Array or contains invalid elements
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
end
