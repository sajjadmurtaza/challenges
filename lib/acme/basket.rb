# frozen_string_literal: true

require_relative 'catalogue'
require_relative 'delivery_rules'
require_relative 'money'

module Acme
  # Shopping basket with add and total methods
  # Dependency injection: accepts catalogue, delivery_rules, and offers
  class Basket
    attr_reader :items

    # @param catalogue [Catalogue]
    # @param delivery_rules [DeliveryRules]
    # @param offers [Array<Offers::Base>]
    def initialize(catalogue:, delivery_rules:, offers: [])
      @catalogue = catalogue
      @delivery_rules = delivery_rules
      @offers = offers
      @items = []
    end

    # Add product to basket by code
    # @param product_code [String]
    # @return [void]
    def add(product_code)
      product = @catalogue.find(product_code)
      @items << product
    end

    # Calculate total including discounts and delivery
    # @return [Money]
    def total
      # Calculate subtotal
      subtotal = @items.reduce(Money.zero) { |sum, item| sum + item.price }

      # Apply all offers
      total_discount = @offers.reduce(Money.zero) { |sum, offer| sum + offer.apply(@items) }

      # Calculate discounted subtotal
      discounted_subtotal = subtotal - total_discount

      # Calculate delivery based on discounted subtotal
      delivery = @delivery_rules.calculate(discounted_subtotal)

      # Return final total
      discounted_subtotal + delivery
    end
  end
end
