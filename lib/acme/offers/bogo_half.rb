# frozen_string_literal: true

require_relative 'base'
require_relative '../money'

module Acme
  module Offers
    # Buy One Get One Half Price offer
    # For every 2 items of target product, apply 50% discount to second item
    class BogoHalf < Base
      # @param product_code [String] code of product this offer applies to
      # @param rate [Float] discount rate (0.5 for 50% off)
      def initialize(product_code:, rate: 0.5)
        super()
        @product_code = product_code
        @rate = rate
        freeze
      end

      # @param items [Array<Product>]
      # @return [Money]
      def apply(items)
        matching_items = items.select { |item| item.code == @product_code }
        return Money.zero if matching_items.empty?

        pairs = matching_items.size / 2
        return Money.zero if pairs.zero?

        discount_per_item = matching_items.first.price * @rate
        discount_per_item * pairs
      end
    end
  end
end
