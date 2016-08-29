module Spree::Calculator
    class InterestCalculator
      class NonComputableOrder < StandardError; end

      def initialize args
        raise NonComputableObject unless computable?(args[:order])
        @interest = Spree::Interest.new(order: args[:order])
      end

      def compute
        @order.item_total * @interest.retrieve
      end

      private

      def computable?(order)
        order.class == Spree::Order && order.respond_to?(:item_total)
      end

    end
  end

end
