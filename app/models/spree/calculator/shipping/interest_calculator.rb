module Spree
  module Calculator::Shipping

    class InterestCalculator < Spree::ShippingCalculator
      def self.description
        Spree.t(:interest_calculator, scope: 'calculators')
      end

      def compute(object)
        byebug
        return 0 unless object.respond_to?(:item_total)
        total = object.item_total
        address = object.billing_address
        zones = address.country.zones + address.state.zones

        if zones.present? && zones.first.max_number_of_installments != 1
          zone_interest = zones.first.interests.select { |i| object.number_of_installments.between?(i.start_number_of_installments,i.end_number_of_installments) }.first
        end

        zone_interest ? total * zone_interest.interest : 0
      end

      def available?(object)
        object.has_installments?
      end

    end

  end
end
