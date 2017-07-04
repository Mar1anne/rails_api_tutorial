require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do

  describe 'GET #show' do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, params: { id: @product.id }
    end

    it 'returns the product information' do
      product_response = json_response
      expect(product_response[:title]).to eql(@product.title)
    end

    it 'has the user as embedded object' do
      product_response = json_response
      expect(product_response[:user][:email]).to eql @product.user.email
    end

    it 'returns status code 200' do
      expect(response.status).to eql 200
    end
  end

  describe 'GET #index' do
    before(:each) do
      4.times { FactoryGirl.create :product }
      get :index
    end

    it 'returns 4 records from db' do
      products_response = json_response
      expect(products_response.count).to eql 4
    end

    it 'returns the user for each object' do
      product_response = json_response
      product_response.each do | product |
        expect(product[:user]).to be_present
      end
    end

    it 'returns status code 200' do
      expect(response.status).to eql 200
    end
  end

  describe 'POST #create' do
    context 'when successfully created' do

      before(:each) do
        user = FactoryGirl.create :user
        @product_attr = FactoryGirl.attributes_for :product
        api_authorization_header user.auth_token
        post :create, params: { user_id: user.id, product: @product_attr }
      end

      it 'renders the json representation' do
        product_response = json_response
        expect(product_response[:title]).to eql @product_attr[:title]
      end

      it { expect(response.status).to eql 201 }
    end

    context 'when not created' do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_prod_attr = { title: 'fdsfsd', price: 'fdfds' }
        api_authorization_header user.auth_token
        post :create, params: { user_id: user.id, product: @invalid_prod_attr }
      end

      it 'renders error json' do
        product_response = json_response
        expect(product_response).to have_key :errors
      end

      it { expect(response.status).to eql 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
    end

    context 'when successfully updated' do
      before(:each) do
        put :update, params:
            { user_id: @user.id, id: @product.id, product: { title: 'title' }}
      end

      it 'renders updated product json' do
        product_response = json_response
        expect(product_response[:title]).to eql 'title'
      end

      it { expect(response.status).to eql 200 }
    end

    context 'when not updated' do
      before(:each) do
        put :update, params:
            { user_id: @user.id, id: @product.id, product: { price: 'title' }}
      end

      it 'renders error json' do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { expect(response.status).to eql 422}
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, params: { user_id: @user.id, id: @product.id }
    end

    it { expect(response.status).to eql 204 }
  end
end
