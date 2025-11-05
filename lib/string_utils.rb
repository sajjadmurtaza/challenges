# frozen_string_literal: true

# Provides string manipulation utilities with custom implementations
module StringUtils
  # Reverses a string without using String#reverse
  #
  # @param string [String] the string to reverse
  # @return [String] the reversed string
  # @raise [ArgumentError] if string is not a String
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
end
