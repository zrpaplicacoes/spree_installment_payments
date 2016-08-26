module SpreeInstallmentPayments
    class InterestCalculator
      class NonComputableObject < StandardError; end

      def initialize order
        @order = order
        raise NonComputableObject unless computable?
      end

      def compute
        total = order.item_total
        address = order.billing_address
        zones = address.country.zones + address.state.zones

        if zones.present? && zones.first.max_number_of_installments != 1
          zone_interest = zones.first.interests.select { |i| order.number_of_installments.between?(i.start_number_of_installments,i.end_number_of_installments) }.first
        end

        zone_interest ? total * zone_interest.interest : 0
      end

      def available?
        order.payments.all? { |payment| payment.accept_installments? }
      end

      private

      def computable?
        order.class == Spree::Order && order.respond_to?(:item_total)
      end

    end
  end

end
