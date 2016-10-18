describe 'Admin Interests Index', type: :feature do
  let(:user) { create(:admin_user) }

  before :each do
    login_as(user, scope: :spree_user)
    visit spree.admin_interests_path
  end

  shared_examples "an index" do
    it 'displays a button to create a new interest' do
      expect(page).to have_content "New Interest"
    end

    it 'displays a title' do
      expect(page).to have_content "Interests"
    end
  end

  context "with interests" do
    let(:payment_method) { create(:credit_card_with_installments) }

    before :each do
      create(:interest, value: "0.0099", name: "Hello world!", payment_method: payment_method, number_of_installments: 123)
      visit spree.admin_interests_path
    end

    it_behaves_like "an index"

    it 'displays all interests' do
      expect(page).to have_content "0.99%"
      expect(page).to have_content "Hello world!"
      expect(page).to have_content "123"
    end

    it 'displays all necessary columns' do
      expect(page).to have_content "Name"
      expect(page).to have_content "Value"
      expect(page).to have_content "Number Of Installments"
      expect(page).to have_content "Payment Method"
    end

  end

  context "without interests" do
    it_behaves_like "an index"

    it 'displays a link to create a new interest' do
      expect(page).to have_link 'Add One'
    end
  end


end