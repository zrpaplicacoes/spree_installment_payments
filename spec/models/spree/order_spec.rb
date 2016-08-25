require 'rails_helper'

describe Spree::Order do

  subject { Spree::Order }

  it 'has a has_installments property' do
    expect(subject.new.respond_to? :has_installments).to be_truthy
  end

  it 'sets has_installments to false' do
    expect(subject.new.has_installments).to be_falsy
  end

end
