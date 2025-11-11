# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Acme::Product do
  describe '#initialize' do
    it 'creates product with valid attributes' do
      price = Acme::Money.from_decimal('32.95')
      product = described_class.new(code: 'R01', name: 'Red Widget', price: price)

      expect(product.code).to eq('R01')
      expect(product.name).to eq('Red Widget')
      expect(product.price).to eq(price)
    end

    it 'freezes the product' do
      product = described_class.new(
        code: 'R01',
        name: 'Red Widget',
        price: Acme::Money.from_decimal('32.95')
      )

      expect(product).to be_frozen
    end

    it 'raises error for empty code' do
      expect do
        described_class.new(code: '', name: 'Widget', price: Acme::Money.zero)
      end.to raise_error(Acme::InvalidConfigError, 'Product code must be a non-empty string')
    end

    it 'raises error for nil code' do
      expect do
        described_class.new(code: nil, name: 'Widget', price: Acme::Money.zero)
      end.to raise_error(Acme::InvalidConfigError)
    end
  end

  describe '#==' do
    it 'returns true for identical products' do
      price = Acme::Money.from_decimal('32.95')
      product1 = described_class.new(code: 'R01', name: 'Red', price: price)
      product2 = described_class.new(code: 'R01', name: 'Red', price: price)

      expect(product1).to eq(product2)
    end

    it 'returns false for different codes' do
      price = Acme::Money.from_decimal('32.95')
      product1 = described_class.new(code: 'R01', name: 'Red', price: price)
      product2 = described_class.new(code: 'G01', name: 'Red', price: price)

      expect(product1).not_to eq(product2)
    end
  end
end
