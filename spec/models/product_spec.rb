require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { build(:product) }

  subject { product }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:price) }
  it { is_expected.to respond_to(:published) }
  it { is_expected.to respond_to(:user_id) }

  it { is_expected.not_to be_published }

  it { should belong_to :user }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { should validate_presence_of(:user_id) }

  describe '.filter_by_title' do
    let!(:product1) { create(:product, title: 'A plasma TV') }
    let!(:product2) { create(:product, title: 'Fastest laptop') }
    let!(:product3) { create(:product, title: 'CD player') }
    let!(:product4) { create(:product, title: 'LCD TV') }

    context "when a 'TV' title pattern is sent" do
      it 'returns 2 products matching' do
        expect(Product.filter_by_title('TV').size).to eq 2
      end

      it 'returns products matching' do
        expect(Product.filter_by_title('TV').sort).to match_array([product1, product4])
      end
    end
  end
end
