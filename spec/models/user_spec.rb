require 'rails_helper'

RSpec.describe User, type: :model do

  before { @user = FactoryGirl.create(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should validate_confirmation_of(:password) }
  it { should validate_uniqueness_of(:auth_token).ignoring_case_sensitivity }

  it { should allow_value('example@domain.com').for(:email) }

  it { should be_valid }

  describe 'generate authentication token' do
    it 'generates a unique token' do
      allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      # Devise.stub(:friendly_token).and_return("auniquetoken123") # Deprecated
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "auniquetoken123"
    end

    it 'generates another token when one already has been taken' do
      existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end

  end

end
