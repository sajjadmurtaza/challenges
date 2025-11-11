# frozen_string_literal: true

require_relative 'money'

module Acme
  # Calculates delivery charge based on tiered rules
  class DeliveryRules
    # @param tiers [Array<Hash>] array of {threshold: Money, charge: Money}
    #   Sorted by threshold ascending. Last tier has no threshold (free delivery)
    def initialize(tiers)
      @tiers = tiers.freeze
      freeze
    end

    # Calculate shipping cost based on subtotal
    # @param subtotal [Money]
    # @return [Money]
    def calculate(subtotal)
      @tiers.each do |tier|
        return tier[:charge] if tier[:threshold].nil? || subtotal < tier[:threshold]
      end
      Money.zero
    end
  end
end
