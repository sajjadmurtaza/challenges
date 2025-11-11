# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'

module Acme
  # Handles monetary values with precision using BigDecimal
  # Stores amounts as cents internally to avoid floating point errors
  class Money
    attr_reader :cents

    # @param cents [Integer] amount in cents
    def initialize(cents)
      @cents = cents
    end

    # Create Money from decimal string (e.g., "32.95")
    # @param amount [String] decimal amount
    # @return [Money]
    def self.from_decimal(amount)
      decimal = BigDecimal(amount.to_s)
      cents = (decimal * 100).round.to_i
      new(cents)
    end

    # Format as currency string
    # @return [String] formatted as $X.XX
    def to_s
      dollars = cents / 100
      remaining_cents = cents.abs % 100
      sign = cents.negative? ? '-' : ''
      format('%<sign>s$%<dollars>d.%<cents>02d', sign: sign, dollars: dollars.abs, cents: remaining_cents)
    end

    # @param other [Money]
    # @return [Money]
    def +(other)
      Money.new(cents + other.cents)
    end

    # @param other [Money]
    # @return [Money]
    def -(other)
      Money.new(cents - other.cents)
    end

    # @param multiplier [Numeric]
    # @return [Money]
    def *(multiplier)
      result = (BigDecimal(cents.to_s) * BigDecimal(multiplier.to_s)).round.to_i
      Money.new(result)
    end

    # @param divisor [Numeric]
    # @return [Money]
    def /(divisor)
      result = (BigDecimal(cents.to_s) / BigDecimal(divisor.to_s)).round.to_i
      Money.new(result)
    end

    # @return [Money]
    def self.zero
      new(0)
    end

    # @param other [Money]
    # @return [Boolean]
    def ==(other)
      other.is_a?(Money) && cents == other.cents
    end

    # @param other [Money]
    # @return [Boolean]
    def <(other)
      cents < other.cents
    end

    # @param other [Money]
    # @return [Boolean]
    def >(other)
      cents > other.cents
    end

    # @param other [Money]
    # @return [Boolean]
    def <=(other)
      cents <= other.cents
    end

    # @param other [Money]
    # @return [Boolean]
    def >=(other)
      cents >= other.cents
    end
  end
end
