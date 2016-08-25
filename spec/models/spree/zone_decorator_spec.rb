require 'rails_helper'

describe Spree::Zone do
  subject { Spree::Zone }

  it 'has a interests method' do
    expect(subject.instance_methods).to include :interests
  end
end
