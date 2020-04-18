require 'rails_helper'

RSpec.describe User, type: :model do
  subject { user }

  let(:user) { build(:user) }

  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }

  it { is_expected.to be_valid }
end
