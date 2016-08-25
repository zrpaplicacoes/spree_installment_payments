module Spree
  Zone.class_eval do
    has_many :zone_interests

    alias_method :interests, :zone_interests

  end
end
