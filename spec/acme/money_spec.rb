# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Acme::Money do
  describe '.from_decimal' do
    it 'creates money from decimal string' do
      money = described_class.from_decimal('32.95')

      expect(money.cents).to eq(3295)
    end

    it 'handles zero' do
      money = described_class.from_decimal('0.00')

      expect(money.cents).to eq(0)
    end

    it 'handles integer strings' do
      money = described_class.from_decimal('50')

      expect(money.cents).to eq(5000)
    end

    it 'rounds to nearest cent' do
      money = described_class.from_decimal('10.999')

      expect(money.cents).to eq(1100)
    end

    it 'handles large amounts' do
      money = described_class.from_decimal('999999.99')

      expect(money.cents).to eq(99_999_999)
    end

    it 'handles negative decimals' do
      money = described_class.from_decimal('-15.50')

      expect(money.cents).to eq(-1550)
    end

    it 'handles numeric input' do
      money = described_class.from_decimal(25.50)

      expect(money.cents).to eq(2550)
    end
  end

  describe '.zero' do
    it 'creates zero money' do
      money = described_class.zero

      expect(money.cents).to eq(0)
    end
  end

  describe '#to_s' do
    it 'formats positive amount as currency' do
      money = described_class.new(3295)

      expect(money.to_s).to eq('$32.95')
    end

    it 'formats zero correctly' do
      money = described_class.zero

      expect(money.to_s).to eq('$0.00')
    end

    it 'formats negative amount with sign' do
      money = described_class.new(-1050)

      expect(money.to_s).to eq('-$11.50')
    end

    it 'pads cents with zero' do
      money = described_class.new(1005)

      expect(money.to_s).to eq('$10.05')
    end

    it 'handles cents only' do
      money = described_class.new(95)

      expect(money.to_s).to eq('$0.95')
    end
  end

  describe '#+ (addition)' do
    it 'adds two money amounts' do
      money1 = described_class.new(1000)
      money2 = described_class.new(500)

      result = money1 + money2

      expect(result.cents).to eq(1500)
    end

    it 'handles adding zero' do
      money = described_class.new(1000)
      zero = described_class.zero

      result = money + zero

      expect(result.cents).to eq(1000)
    end
  end

  describe '#- (subtraction)' do
    it 'subtracts two money amounts' do
      money1 = described_class.new(1000)
      money2 = described_class.new(300)

      result = money1 - money2

      expect(result.cents).to eq(700)
    end

    it 'handles negative results' do
      money1 = described_class.new(500)
      money2 = described_class.new(1000)

      result = money1 - money2

      expect(result.cents).to eq(-500)
    end
  end

  describe '#* (multiplication)' do
    it 'multiplies money by integer' do
      money = described_class.new(100)

      result = money * 5

      expect(result.cents).to eq(500)
    end

    it 'multiplies money by decimal' do
      money = described_class.new(100)

      result = money * 0.5

      expect(result.cents).to eq(50)
    end

    it 'rounds multiplication result' do
      money = described_class.new(333)

      result = money * 0.5

      expect(result.cents).to eq(167)
    end
  end

  describe '#/ (division)' do
    it 'divides money by integer' do
      money = described_class.new(1000)

      result = money / 2

      expect(result.cents).to eq(500)
    end

    it 'rounds division result' do
      money = described_class.new(100)

      result = money / 3

      expect(result.cents).to eq(33)
    end
  end

  describe '#==' do
    it 'returns true for equal amounts' do
      money1 = described_class.new(1000)
      money2 = described_class.new(1000)

      expect(money1).to eq(money2)
    end

    it 'returns false for different amounts' do
      money1 = described_class.new(1000)
      money2 = described_class.new(2000)

      expect(money1).not_to eq(money2)
    end

    it 'returns false for non-Money objects' do
      money = described_class.new(1000)

      expect(money).not_to eq(1000)
    end
  end

  describe 'comparison operators' do
    let(:smaller) { described_class.new(500) }
    let(:larger) { described_class.new(1000) }
    let(:equal) { described_class.new(500) }

    describe '#<=>' do
      it 'returns -1 when less than' do
        expect(smaller <=> larger).to eq(-1)
      end

      it 'returns 0 when equal' do
        expect(smaller <=> equal).to eq(0)
      end

      it 'returns 1 when greater than' do
        expect(larger <=> smaller).to eq(1)
      end
    end
  end
end
