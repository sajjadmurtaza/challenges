# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Acme::DeliveryRules do
  let(:delivery_rules) do
    described_class.new([
                          { threshold: Acme::Money.from_decimal('50.00'), charge: Acme::Money.from_decimal('4.95') },
                          { threshold: Acme::Money.from_decimal('90.00'), charge: Acme::Money.from_decimal('2.95') },
                          { threshold: nil, charge: Acme::Money.zero }
                        ])
  end

  describe '#calculate' do
    context 'when subtotal is under $50' do
      it 'charges $4.95' do
        subtotal = Acme::Money.from_decimal('49.99')

        charge = delivery_rules.calculate(subtotal)

        expect(charge.to_s).to eq('$4.95')
      end

      it 'charges $4.95 at $0' do
        subtotal = Acme::Money.zero

        charge = delivery_rules.calculate(subtotal)

        expect(charge.to_s).to eq('$4.95')
      end
    end

    context 'when subtotal is between $50 and $90' do
      it 'charges $2.95 at exactly $50' do
        subtotal = Acme::Money.from_decimal('50.00')

        charge = delivery_rules.calculate(subtotal)

        expect(charge.to_s).to eq('$2.95')
      end

      it 'charges $2.95 at $89.99' do
        subtotal = Acme::Money.from_decimal('89.99')

        charge = delivery_rules.calculate(subtotal)

        expect(charge.to_s).to eq('$2.95')
      end

      it 'charges $2.95 at $75' do
        subtotal = Acme::Money.from_decimal('75.00')

        charge = delivery_rules.calculate(subtotal)

        expect(charge.to_s).to eq('$2.95')
      end
    end

    context 'when subtotal is $90 or more' do
      it 'charges $0 at exactly $90' do
        subtotal = Acme::Money.from_decimal('90.00')

        charge = delivery_rules.calculate(subtotal)

        expect(charge.to_s).to eq('$0.00')
      end

      it 'charges $0 at $100' do
        subtotal = Acme::Money.from_decimal('100.00')

        charge = delivery_rules.calculate(subtotal)

        expect(charge.to_s).to eq('$0.00')
      end
    end
  end

  describe 'immutability' do
    it 'is frozen' do
      expect(delivery_rules).to be_frozen
    end
  end

  describe 'edge cases' do
    it 'handles very large subtotals' do
      subtotal = Acme::Money.from_decimal('10000.00')

      charge = delivery_rules.calculate(subtotal)

      expect(charge.to_s).to eq('$0.00')
    end

    it 'handles $0.01 subtotal' do
      subtotal = Acme::Money.from_decimal('0.01')

      charge = delivery_rules.calculate(subtotal)

      expect(charge.to_s).to eq('$4.95')
    end

    it 'handles boundary at $49.99' do
      subtotal = Acme::Money.from_decimal('49.99')

      charge = delivery_rules.calculate(subtotal)

      expect(charge.to_s).to eq('$4.95')
    end

    it 'handles boundary at $89.99' do
      subtotal = Acme::Money.from_decimal('89.99')

      charge = delivery_rules.calculate(subtotal)

      expect(charge.to_s).to eq('$2.95')
    end
  end
end
