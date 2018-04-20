require 'rails_helper'

RSpec.describe GramsController, type: :controller do
	describe "grams#index action" do
		it "should successfully show the page" do
			get :index
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#new action" do
		it "Should successfully show the new form" do
			get :new
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#create action" do
		it "Should successfully create a new gram in our database" do
			post :create, params: { gram: { message: 'Hello!' } }
			expect(response).to redirect_to root_path

			gram = Gram.last
			expect(gram.message).to eq('Hello!')
		end

		it "Should properly deal with validation errors" do
			gram_count = Gram.count
			post :create, params: { gram: {message: ''} }
			expect(response).to have_http_status(:unprocessable_entity)
			gram = Gram.last
			expect(Gram.count).to eq gram_count
		end
	end

end
