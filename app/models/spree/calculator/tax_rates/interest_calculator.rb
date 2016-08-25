module Spree
  module Calculator::TaxRates

    class InterestCalculator < Spree::Calculator
      def self.description
        Spree.t(:interest_calculator, scope: 'calculators')
      end

      def compute(object=nil)
        byebug
      end

      def available?(object)
        byebug
      end
    end

  end
end
