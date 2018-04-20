require 'rails_helper'

RSpec.describe GramsController, type: :controller do

	describe "grams#index action" do
		# - When someones web browser performs a GET HTTP request to the apps root url
		# - the page should display properly
		it "should successfully show the page" do
			get :index
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#new action" do
		# - When an unauthenticated users browser
		# - performs a GET HTTP request to the url that looks like grams/new
		# - they should be redirected to the page where they can sign in
		it "Should require users to be logged in" do
			get :new
			expect(response).to redirect_to new_user_session_path
		end

		# - When an authenticated users browser
		# - performs a GET HTTP request to a url that looks like grams/new
		# - the page should display successfully
		it "Should successfully show the new form" do
			user = User.create(
				email:									'fakeuser@gmail.com',
				password:								'fakepassword',
				password_confirmation: 	'fakepassword'
			)
			sign_in user
			get :new
			expect(response).to have_http_status(:success)
		end
	end

	describe "grams#create action" do
		# - When someone is not signed in
		# - and browser performs a POST HTTP request to url that looks like /grams
		# - they should be redirected to the page where they can sign in
		it "Should require users to be logged in" do
			post :create, params: { gram: { message: 'Hello!' } }
			expect(response).to redirect_to new_user_session_path
		end

		# - When an authenticated users
		# - browser performs a POST HTTP request to a url that looks like /grams
		# - a new gram should be added to the database
		# - the user should be redirected to the root page
		it "Should successfully create a new gram in our database" do
			user = User.create(
				email:									'fakeuser@gmail.com',
				password:								'fakepassword',
				password_confirmation: 	'fakepassword'
			)
			sign_in user

			post :create, params: { gram: { message: 'Hello!' } }
			expect(response).to redirect_to root_path

			gram = Gram.last
			expect(gram.message).to eq('Hello!')
			expect(gram.user).to eq user
		end

		# - When a authenticated user submits the gram form and performs a POST HTTP
		# - request to the url that looks like grams
		# - Our server should result in the HTTP request unprocessable entity
		# - the database should not have added any entries
		it "Should properly deal with validation errors" do
			user = User.create(
				email:									'fakeuser@gmail.com',
				password:								'fakepassword',
				password_confirmation: 	'fakepassword'
			)
			sign_in user

			gram_count = Gram.count
			post :create, params: { gram: {message: ''} }
			expect(response).to have_http_status(:unprocessable_entity)
			gram = Gram.last
			expect(Gram.count).to eq gram_count
		end
	end

end
