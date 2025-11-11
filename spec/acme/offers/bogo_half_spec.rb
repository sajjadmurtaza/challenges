# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Acme::Offers::BogoHalf do
  let(:offer) { described_class.new(product_code: 'R01', rate: 0.5) }

  let(:red_widget) do
    Acme::Product.new(code: 'R01', name: 'Red Widget', price: Acme::Money.from_decimal('32.95'))
  end

  let(:green_widget) do
    Acme::Product.new(code: 'G01', name: 'Green Widget', price: Acme::Money.from_decimal('24.95'))
  end

  describe '#apply' do
    context 'with no matching products' do
      it 'returns zero discount' do
        items = [green_widget, green_widget]

        discount = offer.apply(items)

        expect(discount).to eq(Acme::Money.zero)
      end

      it 'returns zero for empty basket' do
        discount = offer.apply([])

        expect(discount).to eq(Acme::Money.zero)
      end
    end

    context 'with one matching product' do
      it 'returns zero discount' do
        items = [red_widget]

        discount = offer.apply(items)

        expect(discount).to eq(Acme::Money.zero)
      end
    end

    context 'with two matching products' do
      it 'discounts one item at 50%' do
        items = [red_widget, red_widget]

        discount = offer.apply(items)

        # $32.95 * 0.5 = $16.475 -> $16.48
        expect(discount.to_s).to eq('$16.48')
      end
    end

    context 'with three matching products' do
      it 'discounts one item (only one pair)' do
        items = [red_widget, red_widget, red_widget]

        discount = offer.apply(items)

        # Only 1 pair: $32.95 * 0.5 = $16.48
        expect(discount.to_s).to eq('$16.48')
      end
    end

    context 'with four matching products' do
      it 'discounts two items (two pairs)' do
        items = [red_widget, red_widget, red_widget, red_widget]

        discount = offer.apply(items)

        # 2 pairs: $32.95 * 0.5 * 2 = $32.96
        expect(discount.to_s).to eq('$32.96')
      end
    end

    context 'with mixed products' do
      it 'only applies to matching products' do
        items = [red_widget, green_widget, red_widget]

        discount = offer.apply(items)

        # 1 pair of red: $16.48
        expect(discount.to_s).to eq('$16.48')
      end
    end
  end

  describe 'immutability' do
    it 'is frozen' do
      expect(offer).to be_frozen
    end
  end

  describe 'custom rate' do
    it 'applies custom discount rate' do
      custom_offer = described_class.new(product_code: 'R01', rate: 0.25)
      items = [red_widget, red_widget]

      discount = custom_offer.apply(items)

      expect(discount.to_s).to eq('$8.24')
    end

    it 'works with 100% discount rate' do
      full_discount = described_class.new(product_code: 'R01', rate: 1.0)
      items = [red_widget, red_widget]

      discount = full_discount.apply(items)

      expect(discount.to_s).to eq('$32.95')
    end

    it 'works with 75% discount rate' do
      custom_offer = described_class.new(product_code: 'R01', rate: 0.75)
      items = [red_widget, red_widget]

      discount = custom_offer.apply(items)

      expect(discount.cents).to eq(2471)
    end
  end

  describe 'with large quantities' do
    it 'handles many items' do
      items = Array.new(10, red_widget)

      discount = offer.apply(items)

      expect(discount.cents).to eq(8240)
    end
  end
end
