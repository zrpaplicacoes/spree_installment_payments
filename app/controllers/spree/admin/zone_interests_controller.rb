module Spree
  module Admin
    class ZoneInterestsController < ResourceController
      before_action :load_data, except: [:index]

      private

      def collection
        params[:q] ||= {}
        params[:q][:s] ||= "name asc"
        @search = super.ransack(params[:q])
        @zone_interests = @search.result.page(params[:page]).per(params[:per_page])
      end

      def load_data
        @zones = Zone.order(:name)
        @payment_methods = PaymentMethod.order(:name)
        @zone_interests = ZoneInterest.order(:name)
      end

    end

  end
end
