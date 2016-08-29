module Spree::Calculator
    class InterestCalculator
      class NonComputableObject < StandardError; end

      def initialize order
        raise NonComputableObject unless computable?(order)
        @interest = Spree::Interest.new(order)
      end

      def compute
        if available?
          interests = interests_for_zones
          interests.each do |zone_id, interest| {

          }
        end

        zone_interest ? total * zone_interest.interest : 0
      end

      def available?
        order.payments.all? { |payment| payment.accept_installments? } &&    # all selected payment methods accept installments
        @order_zones.present? &&                                             # order is placed inside a zone
        @order_zones.all? { |zone| zone.has_installments? }                  # all zones allows installments
      end

      private

      def setup
        @order_current_total = @order.item_total
        @billing_address = @order.billing_address
        @order_zones = @billing_address ? ( @billing_address.country.zones | @billing_address.state.zones ) : []
      end

      def computable?(order)
        order.class == Spree::Order && order.respond_to?(:item_total)
      end

      def interest_resolution
        interests = interests_for_zones
        @order_zones.max { |zone| zone.interests. }
      end

      def interests_for_zones
        interests_by_zone = {}

        @order_zones.each do |zone|
          interests_by_zone[zone.id] = interests_for(zone)
        end

        interests_by_zone
      end

      def interests_for(zone)
        interests = []

        order.payments.each do |payment|
          interests << zone.interests.select { |interest| interest.is_interest_for(payment.installments) }.first
        end if available?

        interests
      end

    end
  end

end
