require 'spree_core'
require 'spree_installment_payments/engine'

# Allow installments to be passed to payment
Spree::PermittedAttributes.payment_attributes << :installments