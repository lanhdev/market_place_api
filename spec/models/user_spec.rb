require 'rails_helper'

RSpec.describe User, type: :model do
  subject { user }

  let(:user) { build(:user) }

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:auth_token) }

  it { is_expected.to be_valid }

  it { should have_many(:products) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_confirmation_of(:password) }
  it { should allow_value('example@domain.com').for(:email) }
  it { should validate_uniqueness_of(:auth_token) }

  describe '#generate_authentication_token!' do
    let(:existing_user) { create(:user, auth_token: 'auniquetoken123') }

    it 'generates a unique token' do
      allow(Devise).to receive(:friendly_token).and_return('auniquetoken123')
      user.generate_authentication_token!
      expect(user.auth_token).to eq 'auniquetoken123'
    end

    it 'generates another token when one already has been taken' do
      user.generate_authentication_token!
      expect(user.auth_token).not_to eq existing_user.auth_token
    end
  end

  describe '#products association' do
    let(:product) { create(:product) }
    let(:user) { product.user }

    before do
      user.destroy
    end

    it 'destroy the associated products on self destruct' do
      expect { Product.find(product.id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
