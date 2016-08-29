module Spree
  module Admin
    class ZoneInterestsController < ResourceController
      before_action :load_data, except: [:index]

      def index
      end

      def new
      end

      def create
      end

      private

      def load_data
        @countries = Country.order(:name)
        @states = State.order(:name)
        @zone_interests = ZoneInterest.order(:name)
      end

    end

  end
end
