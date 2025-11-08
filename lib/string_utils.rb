# frozen_string_literal: true

module StringUtils
  # @param string [String]
  # @return [String] reversed string
  # @raise [ArgumentError] if not a String
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
