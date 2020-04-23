require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe 'GET #index' do
    let!(:products) { create_list(:product, 5) }

    before(:each) do
      get :index
    end

    it 'returns 5 records from database' do
      products_response = json_response[:products]
      expect(products_response.size).to eq 5
    end

    it { should respond_with 200 }
  end

  describe 'GET #show' do
    before(:each) do
      @product = FactoryBot.create(:product)
      get :show, params: { id: @product.id }
    end

    it 'returns the information about the product' do
      product_response = json_response[:product]
      expect(product_response[:title]).to eq @product.title
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        user = FactoryBot.create(:user)
        @product_attributes = FactoryBot.attributes_for(:product)
        api_authorization_header(user.auth_token)
        post :create, params: { user_id: user.id, product: @product_attributes }
      end

      it 'renders the json representation for the product record just created' do
        product_response = json_response[:product]
        expect(product_response[:title]).to eq @product_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        user = FactoryBot.create(:user)
        @invalid_product_attributes = { title: 'Smart TV', price: 'Twelve dollars' }
        api_authorization_header(user.auth_token)
        post :create, params: { user_id: user.id, product: @invalid_product_attributes }
      end

      it 'renders an errors json' do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it 'renders the json errors on why the product could not be created' do
        product_response = json_response
        expect(product_response[:errors][:price]).to include 'is not a number'
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @user = FactoryBot.create(:user)
      @product = FactoryBot.create(:product, user: @user)
      api_authorization_header(@user.auth_token)
    end

    context 'when is successfully updated' do
      before(:each) do
        patch :update, params: {
          user_id: @user.id,
          id: @product.id,
          product: { title: 'An expensive TV' }
        }
      end

      it 'renders the json representation for the updated product' do
        product_response = json_response[:product]
        expect(product_response[:title]).to eq 'An expensive TV'
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        patch :update, params: {
          user_id: @user.id,
          id: @product.id,
          product: { price: 'two hundred' }
        }
      end

      it 'renders an errors json' do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it 'renders the json errors on why the product could not be updated' do
        product_response = json_response
        expect(product_response[:errors][:price]).to include 'is not a number'
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryBot.create(:user)
      api_authorization_header(@user.auth_token)
      @product = FactoryBot.create(:product, user: @user)
      delete :destroy, params: {
        user_id: @user.id,
        id: @product.id
      }
    end

    it { should respond_with 204 }
  end
end
