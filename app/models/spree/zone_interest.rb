module Spree
  class ZoneInterest < ActiveRecord::Base
    belongs_to :spree_zone

    alias_method :zone, :spree_zone
  end
end
