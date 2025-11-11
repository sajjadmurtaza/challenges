# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Acme::Offers::Base do
  describe '#apply' do
    it 'raises NotImplementedError when called directly' do
      base = described_class.new

      expect { base.apply([]) }.to raise_error(
        NotImplementedError,
        'Acme::Offers::Base must implement #apply'
      )
    end
  end
end
