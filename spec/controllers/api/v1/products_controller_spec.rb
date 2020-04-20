require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe 'GET #index' do
    let!(:products) { create_list(:product, 5) }

    before(:each) do
      get :index
    end

    it 'returns 5 records from database' do
      products_response = json_response
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
      product_response = json_response
      expect(product_response[:title]).to eq @product.title
    end

    it { should respond_with 200 }
  end
end
