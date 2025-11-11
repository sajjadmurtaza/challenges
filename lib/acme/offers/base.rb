# frozen_string_literal: true

module Acme
  module Offers
    # Base interface for offers (Strategy pattern)
    class Base
      # Calculate discount for given items
      # @param items [Array<Product>] items in basket
      # @return [Money] discount amount
      def apply(items)
        raise NotImplementedError, "#{self.class} must implement #apply"
      end
    end
  end
end
