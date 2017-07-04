require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  include FactoryGirl

  # before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }
  # before(:each) { request.headers['Content-Type'] = Mime::JSON.to_s }

  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, params: { id: @user.id }
      # get :show, id: @user.id, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it 'has the product ids as an embeded object' do
      user_response = json_response
      expect(user_response[:product_ids]).to eql []
    end

    it 'responds with status code 200' do
      expect(response.status).to eql(200)
    end

  end

  describe 'POST #create' do
    context 'when successfully created' do
      before(:each) do
        @user_attr = FactoryGirl.attributes_for(:user)
        post :create, params: @user_attr
      end

      it 'renders json representation of user' do
        user_response = json_response
        expect(user_response[:email]).to eql(@user_attr[:email])
      end

      it 'returns 201 status code' do
        expect(response.status).to eql(201)
      end

    end

    context 'when not created' do
      before(:each) do
        @invalid_user_attr = { password: '1231322', password_confirmation: '1231322' }
        post :create, params: @invalid_user_attr
      end

      # it 'renders error json' do
      #   response = JSON.parse(response.body, symbolize_names: true)
      #   expect(response[:errors]).not_to be_nil
      # end

      it 'responds with 422' do
        expect(response.status).to eql(422)
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when successfully created' do
      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        patch :update, params: { id: @user.id, email: 'new@email.com' }
      end

      it 'renders user json' do
        user_response = json_response
        expect(user_response[:email]).to eql('new@email.com')
      end

      it 'returns status code 200' do
        expect(response.status).to eql(200)
      end

    end

    context 'when not created' do

      before(:each) do
        @user = FactoryGirl.create :user
        api_authorization_header @user.auth_token
        patch :update, params: { id: @user.id, email: 'email.com' }
      end

      it 'renders error json' do
        error_response = json_response
        expect(error_response).not_to be_nil
      end

      it 'returns status code 422' do
        expect(response.status).to eql(422)
      end
    end
  end


  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      delete :destroy, params: { id: @user.id }
    end

    it 'should respond with 204' do
      expect(response.status).to eql(204)
    end
  end
end