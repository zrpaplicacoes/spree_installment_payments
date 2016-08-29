module Spree
  module Admin
    class ZoneInterestsController < ResourceController
      before_action :load_data, except: [:index]

      def index
      end

      def new
        @zone_interest = ZoneInterest.new
      end

      def create
        unless @zone_interest.save
          flash[:error] = @zone_interest.errors.messages.join(', ')
        end
      end

      private

      def collection
        params[:q] ||= {}
        params[:q][:s] ||= "name asc"
        @search = super.ransack(params[:q])
        @zone_interests = @search.result.page(params[:page]).per(params[:per_page])
      end

      def load_data
        @countries = Country.order(:name)
        @states = State.order(:name)
        @zone_interests = ZoneInterest.order(:name)
      end

    end

  end
end
