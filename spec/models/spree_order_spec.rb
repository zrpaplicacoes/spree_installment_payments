require 'spec_helper'

describe Spree::Order do

  it 'has a has_installments property' do
    expect(subject.attributes).to include :has_installments
  end

end
