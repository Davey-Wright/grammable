require 'rails_helper'

RSpec.describe GramsController, type: :controller do

	describe "grams#index action" do
		# - When someones web browser performs a GET HTTP request to the apps root url
		# - the page should display properly
		it 'should display the root page properly' do
			get :index
			expect(response).to have_http_status(:success)
			expect(response).to render_template('grams/index')
		end
	end

	describe "grams#new action" do
		# - When an unauthenticated users browser
		# - performs a GET HTTP request to the url that looks like grams/new
		# - they should be redirected to the page where they can sign in
		it "should redirect the unauthenticated user to the login page" do
			get :new
			expect(response).to redirect_to new_user_session_path
		end

		# - When an authenticated users browser
		# - performs a GET HTTP request to a url that looks like grams/new
		# - the page should display successfully
		it "Should display the page properly for authenticated users" do
			user = FactoryBot.create(:user)
			sign_in user

			get :new
			expect(response).to have_http_status(:success)
			expect(response).to render_template('grams/new')
		end
	end

	describe 'grams#create' do
		# - When someone is not signed in
		# - and browser performs a POST HTTP request to url that looks like /grams
		# - they should be redirected to the page where they can sign in
		it "Should redirect the user to the login page" do
			post :create, params: { gram: { message: 'Hola!' } }
			expect(response).to redirect_to new_user_session_path
		end

		#  When an authenticated users
		# - browser performs a POST HTTP request to a url that looks like /grams
		# - a new gram should be added to the database
		# - the user should be redirected to the root page
		it "Should successfully create a gram and store it in our database" do
			user = FactoryBot.create(:user)
			sign_in user

			post :create, params: { gram: { message: 'Ola!' } }
			expect(response).to redirect_to root_path

			gram = user.grams.last
			expect(gram.message).to eq('Ola!')
			expect(gram.user).to eq user
		end

		#  When a authenticated user submits the gram form and performs a POST HTTP
		# - request to the url that looks like grams
		# - Our server should result in the HTTP request unprocessable entity
		# - the database should not have added any entries
		it "Should properly deal with validation errors" do
			user = FactoryBot.create(:user)
			sign_in user
			gram_count = user.grams.count
			post :create, params: { gram: { message: '' } }
			expect(response).to have_http_status(:unprocessable_entity)
			expect(user.grams.count).to eq(gram_count)
		end
	end

	describe 'grams#show action' do
		# - When a user makes a GET request
		# - to a url with an id of a VALID gram
		# - the correct gram should be displayed
		it "Should display the page if the gram is found" do
			gram = FactoryBot.create(:gram)
			get :show, params: { id: gram.id }
			expect(response).to have_http_status(:success)
		end

		# - When a user makes a GET request
		# - to a url with an INVALID/non existent gram
		# - a 404 not found message should be displayed
		it "Should return a 404 message if the gram is not found" do
			get :show, params: { id: 'shaka' }
			expect(response).to have_http_status(:not_found)
		end
	end

	describe 'grams#edit action' do

		it "Should display the edit form if the gram is found" do
			gram = FactoryBot.create(:gram)
			get :edit, params: { id: gram.id }
			expect(response).to have_http_status(:success)
		end

		it "Should return a 404 message if the gram is not found" do
			get :edit, params: { id: "shaka" }
			expect(response).to have_http_status(:not_found)
		end
	end

	describe 'grams#update action' do

		# - when a user makes a PUT request
		# - to the url and the gram is not found
		# - a 404 status should be rendered
		it "Should display a 404 status if the gram is not found" do
			patch :update, params: { id: 'YOLOswagger', gram: { message: 'Senor!' } }
			expect(response).to have_http_status(:not_found)
		end

		# - when a user makes a PUT request
		# - to the url gram/edit/id and the gram is found
		# - it should successfully update the gram
		it "Should successfully update the gram" do
			gram = FactoryBot.create(:gram)
			patch :update, params: { id: gram.id, gram: { message: 'Senor!' } }
			expect(response).to redirect_to grams_path(gram.id)

			gram.reload
			expect(gram.message).to eq('Senor!')
		end

		# - when a user makes a PUT request
		# - to the url gram/edit/id and the gram is found
		# - but the gram is not valid
		# - the proper errors should be rendered
		it "Should render proper errors on the page" do
			gram = FactoryBot.create(:gram, message: 'Initial Value')
			patch :update, params: { id: gram.id, gram: { message: '' } }
			expect(response).to have_http_status(:unprocessable_entity)

			gram.reload
			expect(gram.message).to eq('Initial Value')
		end
	end

end
