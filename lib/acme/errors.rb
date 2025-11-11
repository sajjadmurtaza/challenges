# frozen_string_literal: true

module Acme
  class Error < StandardError; end

  class UnknownProductError < Error; end

  class InvalidConfigError < Error; end

  class InvalidPriceError < Error; end
end
