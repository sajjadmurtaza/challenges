# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Acme::Catalogue do
  let(:red_widget) do
    Acme::Product.new(code: 'R01', name: 'Red Widget', price: Acme::Money.from_decimal('32.95'))
  end

  let(:green_widget) do
    Acme::Product.new(code: 'G01', name: 'Green Widget', price: Acme::Money.from_decimal('24.95'))
  end

  let(:catalogue) { described_class.new([red_widget, green_widget]) }

  describe '#find' do
    it 'returns product for valid code' do
      product = catalogue.find('R01')

      expect(product).to eq(red_widget)
    end

    it 'raises error for unknown code' do
      expect do
        catalogue.find('INVALID')
      end.to raise_error(Acme::UnknownProductError, 'Unknown product code: INVALID')
    end
  end

  describe '#all' do
    it 'returns all products' do
      expect(catalogue.all).to contain_exactly(red_widget, green_widget)
    end
  end

  describe '#exists?' do
    it 'returns true for existing code' do
      expect(catalogue.exists?('R01')).to be true
    end

    it 'returns false for non-existing code' do
      expect(catalogue.exists?('INVALID')).to be false
    end
  end

  describe 'immutability' do
    it 'is frozen' do
      expect(catalogue).to be_frozen
    end
  end
end
