require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  describe 'POST #create' do

    before(:each) do
      @user = FactoryGirl.create :user
    end

    context 'when credentials are correct' do

      before(:each) do
        credentials = { email: @user.email, password: '123456789' }
        post :create, params: { session: credentials }
      end

      it 'returns user record' do
        @user.reload
        expect(json_response[:auth_token]).to eql @user.auth_token
      end

      it { expect(response.status).to eql 200 }

    end

    context 'when credentials are incorrect' do
      before(:each) do
        credentials = { email: @user.email, password: 'invalid' } # not the same pass from Factory
        post :create, params: { session: credentials }
      end

      it 'returns error json' do

      end

      it { expect(response.status).to eql 422 }
    end

  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user, scope: :user
      delete :destroy, params: { id: @user.auth_token }
    end

    it { expect(response.status).to eql 204 }
  end
end
