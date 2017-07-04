require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do

  describe 'GET #index' do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      4.times { FactoryGirl.create :order, user: current_user }
      get :index, params: { user_id: current_user.id }
    end

    it 'returns 4 user records from the user' do
      expect(json_response.count).to eql 4
    end

    it { expect(response.status).to eql 200 }
  end

  describe 'GET #show' do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      @order = FactoryGirl.create :order, user: current_user
      get :show, params: { user_id: current_user.id, id: @order.id }
    end

    it 'returns the user order matching the id' do
      expect(json_response[:id]).to eql @order.id
    end

    it 'includes the total for the order' do
      expect(json_response[:total]).to eql @order.total.to_s
    end

    it 'includes the products for the order' do
      expect(json_response[:total]).not_to be_nil
    end

    it { expect(response.status).to eql 200 }
  end

  describe 'POST #create' do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token

      product_1 = FactoryGirl.create :product
      product_2 = FactoryGirl.create :product

      order_params = { product_ids: [product_1.id, product_2.id] }
      post :create, params: { user_id: current_user.id, order: order_params }
    end

    it 'returns just user order record' do
      expect(json_response[:id]).not_to be_nil
    end

    it { expect(response.status).to eql 201 }
  end
end
