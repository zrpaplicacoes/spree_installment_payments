module Spree
  module Calculator::TaxRates

    class InterestCalculator < Spree::Calculator
      def self.description
        Spree.t(:interest_calculator, scope: 'calculators')
      end

      def compute(order=nil)
        total = order.item_total
        address = order.billing_address
        zones = address.country.zones + address.state.zones

        if zones.present? && zones.first.max_number_of_installments != 1
          zone_interest = zones.first.interests.select { |i| order.number_of_installments.between?(i.start_number_of_installments,i.end_number_of_installments) }.first
        end

        zone_interest ? total * zone_interest.interest : 0
      end

      def available?(order)
        order.has_installments?
      end
    end

  end
end
