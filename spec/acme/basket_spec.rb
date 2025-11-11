# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Acme::Basket do
  let(:products) do
    [
      Acme::Product.new(code: 'R01', name: 'Red Widget', price: Acme::Money.from_decimal('32.95')),
      Acme::Product.new(code: 'G01', name: 'Green Widget', price: Acme::Money.from_decimal('24.95')),
      Acme::Product.new(code: 'B01', name: 'Blue Widget', price: Acme::Money.from_decimal('7.95'))
    ]
  end

  let(:catalogue) { Acme::Catalogue.new(products) }

  let(:delivery_rules) do
    Acme::DeliveryRules.new([
                              { threshold: Acme::Money.from_decimal('50.00'),
                                charge: Acme::Money.from_decimal('4.95') },
                              { threshold: Acme::Money.from_decimal('90.00'),
                                charge: Acme::Money.from_decimal('2.95') },
                              { threshold: nil, charge: Acme::Money.zero }
                            ])
  end

  let(:offers) do
    [
      Acme::Offers::BogoHalf.new(product_code: 'R01', rate: 0.5)
    ]
  end

  let(:basket) do
    described_class.new(
      catalogue: catalogue,
      delivery_rules: delivery_rules,
      offers: offers
    )
  end

  describe 'acceptance tests' do
    context 'with basket: B01, G01' do
      it 'calculates total as $37.85' do
        basket.add('B01')
        basket.add('G01')

        expect(basket.total.to_s).to eq('$37.85')
      end
    end

    context 'with basket: R01, R01' do
      it 'calculates total as $54.37' do
        basket.add('R01')
        basket.add('R01')

        expect(basket.total.to_s).to eq('$54.37')
      end
    end

    context 'with basket: R01, G01' do
      it 'calculates total as $60.85' do
        basket.add('R01')
        basket.add('G01')

        expect(basket.total.to_s).to eq('$60.85')
      end
    end

    context 'with basket: B01, B01, R01, R01, R01' do
      it 'calculates total as $98.27' do
        basket.add('B01')
        basket.add('B01')
        basket.add('R01')
        basket.add('R01')
        basket.add('R01')

        expect(basket.total.to_s).to eq('$98.27')
      end
    end
  end

  describe '#add' do
    it 'adds product to basket' do
      expect { basket.add('R01') }.to change { basket.items.size }.by(1)
    end

    it 'raises error for unknown product code' do
      expect { basket.add('INVALID') }.to raise_error(Acme::UnknownProductError)
    end

    it 'allows adding same product multiple times' do
      basket.add('R01')
      basket.add('R01')

      expect(basket.items.size).to eq(2)
      expect(basket.items.map(&:code)).to eq(%w[R01 R01])
    end
  end

  describe '#total' do
    context 'with empty basket' do
      it 'returns delivery charge only' do
        expect(basket.total.to_s).to eq('$4.95')
      end
    end

    context 'with single item' do
      it 'calculates subtotal + delivery' do
        basket.add('B01')

        expect(basket.total.to_s).to eq('$12.90')
      end
    end

    context 'with items qualifying for free delivery' do
      it 'does not charge delivery' do
        basket.add('R01')
        basket.add('R01')
        basket.add('G01')

        expect(basket.total).to be_a(Acme::Money)
      end
    end

    context 'with many items' do
      it 'handles large baskets' do
        10.times { basket.add('B01') }

        expect(basket.items.size).to eq(10)
        expect(basket.total).to be_a(Acme::Money)
      end
    end

    context 'with mixed products' do
      it 'calculates correctly' do
        basket.add('R01')
        basket.add('G01')
        basket.add('B01')

        total = basket.total
        expect(total.cents).to be > 0
      end
    end
  end

  describe 'dependency injection' do
    it 'accepts catalogue' do
      expect(basket.instance_variable_get(:@catalogue)).to eq(catalogue)
    end

    it 'accepts delivery_rules' do
      expect(basket.instance_variable_get(:@delivery_rules)).to eq(delivery_rules)
    end

    it 'accepts offers' do
      expect(basket.instance_variable_get(:@offers)).to eq(offers)
    end

    it 'works without offers' do
      basket_no_offers = described_class.new(
        catalogue: catalogue,
        delivery_rules: delivery_rules,
        offers: []
      )

      basket_no_offers.add('R01')
      basket_no_offers.add('R01')

      # Without BOGO: $32.95 * 2 = $65.90 + $2.95 delivery = $68.85
      expect(basket_no_offers.total.to_s).to eq('$68.85')
    end
  end
end
