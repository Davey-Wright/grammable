# require 'rails_helper'
#
# RSpec.describe GramsController, type: :controller do
#
# 	describe "grams#index action" do
# 		it 'should display the root page properly' do
# 			get :index
# 			expect(response).to have_http_status(:success)
# 			expect(response).to render_template('grams/index')
# 		end
# 	end
#
# 	describe "grams#new action" do
# 		it "should redirect the unauthenticated user to the login page" do
# 			get :new
# 			expect(response).to redirect_to new_user_session_path
# 		end
#
# 		it "Should display the page properly for authenticated users" do
# 			user = FactoryBot.create(:user)
# 			sign_in user
#
# 			get :new
# 			expect(response).to have_http_status(:success)
# 			expect(response).to render_template('grams/new')
# 		end
# 	end
#
# 	describe 'grams#create' do
# 		it "Should redirect the user to the login page" do
# 			post :create, params: { gram: { message: 'Hola!' } }
# 			expect(response).to redirect_to new_user_session_path
# 		end
#
# 		it "Should successfully create a gram and store it in our database" do
# 			user = FactoryBot.create(:user)
# 			sign_in user
# 			post :create, params: {
# 				gram: {
# 					message: 'Ola!',
# 					photo: fixture_file_upload('/hanger.jpg', 'image/jpeg')
# 				}
# 			}
# 			expect(response).to redirect_to root_path
#
# 			gram = user.grams.last
# 			expect(gram.message).to eq('Ola!')
# 			expect(gram.user).to eq user
# 		end
#
# 		it "Should properly deal with validation errors" do
# 			user = FactoryBot.create(:user)
# 			sign_in user
# 			gram_count = user.grams.count
# 			post :create, params: { gram: { message: '' } }
# 			expect(response).to have_http_status(:unprocessable_entity)
# 			expect(user.grams.count).to eq(gram_count)
# 		end
# 	end
#
# 	describe 'grams#show action' do
# 		it "Should display the page if the gram is found" do
# 			gram = FactoryBot.create(:gram)
#
# 			get :show, params: { id: gram.id }
# 			expect(response).to have_http_status(:success)
# 		end
#
# 		it "Should return a 404 message if the gram is not found" do
# 			get :show, params: { id: 'shaka' }
# 			expect(response).to have_http_status(:not_found)
# 		end
# 	end
#
# 	describe 'grams#edit action' do
#
# 		it "Should redirect unauthenticated user to login page" do
# 			gram = FactoryBot.create(:gram)
#
# 			get :edit, params: { id: gram.id }
# 			expect(response).to redirect_to new_user_session_path
# 		end
#
# 		it "Shouldn't let a user who did not create the gram edit a gram" do
# 			gram = FactoryBot.create(:gram)
# 			user = FactoryBot.create(:user)
# 			sign_in user
#
# 			get :edit, params: { id: gram.id }
# 			expect(response).to have_http_status(:forbidden)
# 		end
#
# 		it "Should display the edit form if the gram is found" do
# 			gram = FactoryBot.create(:gram)
# 			sign_in gram.user
#
# 			get :edit, params: { id: gram.id }
# 			expect(response).to have_http_status(:success)
# 		end
#
# 		it "Should return a 404 message if the gram is not found" do
# 			user = FactoryBot.create(:user)
# 			sign_in user
#
# 			get :edit, params: { id: "shaka" }
# 			expect(response).to have_http_status(:not_found)
# 		end
# 	end
#
# 	describe 'grams#update action' do
#
# 		it "Should redirect unauthenticated user to login page" do
# 			gram = FactoryBot.create(:gram)
#
# 			patch :update, params: { id: gram.id, gram: { message: gram.message } }
# 			expect(response).to redirect_to new_user_session_path
# 		end
#
# 		it "Shouldn't let a user who did not create the gram edit a gram" do
# 			gram = FactoryBot.create(:gram)
# 			user = FactoryBot.create(:user)
# 			sign_in user
#
# 		 	patch :update, params: { id: gram.id, gram: { message: 'new message' } }
# 			expect(response).to have_http_status(:forbidden)
# 		end
#
# 		it "Should display a 404 status if the gram is not found" do
# 			user = FactoryBot.create(:user)
# 			sign_in user
#
# 			patch :update, params: { id: 'YOLOswagger', gram: { message: 'Senor!' } }
# 			expect(response).to have_http_status(:not_found)
# 		end
#
# 		it "Should successfully update the gram" do
# 			gram = FactoryBot.create(:gram)
# 			sign_in gram.user
#
# 			patch :update, params: { id: gram.id, gram: { message: 'Senor!' } }
# 			expect(response).to redirect_to grams_path(gram.id)
#
# 			gram.reload
# 			expect(gram.message).to eq('Senor!')
# 		end
#
# 		it "Should render proper errors on the page" do
# 			gram = FactoryBot.create(:gram, message: 'Initial Value')
# 			sign_in gram.user
# 			patch :update, params: { id: gram.id, gram: { message: '' } }
# 			expect(response).to have_http_status(:unprocessable_entity)
#
# 			gram.reload
# 			expect(gram.message).to eq('Initial Value')
# 		end
# 	end
#
# 	describe 'grams#destroy action' do
#
# 		it "Should redirect unauthenticated user to login page" do
# 			gram = FactoryBot.create(:gram)
# 			delete :destroy, params: { id: gram.id }
# 			expect(response).to redirect_to new_user_session_path
# 		end
#
# 		it "Shouldn't let a user who did not create the gram edit a gram" do
# 			gram = FactoryBot.create(:gram)
# 			user = FactoryBot.create(:user)
# 			sign_in user
#
# 			get :destroy, params: { id: gram.id }
# 			expect(response).to have_http_status(:forbidden)
# 		end
#
# 		it "Should delete the the gram from the database" do
# 			gram = FactoryBot.create(:gram)
# 			sign_in gram.user
#
# 			delete :destroy, params: { id: gram.id, gram: { message: gram.message }}
# 			expect(response).to redirect_to root_path
#
# 			gram = Gram.find_by_id(gram.id)
# 			expect(gram).to eq(nil)
# 		end
#
# 		it "Should show a 404 not found message" do
# 			user = FactoryBot.create(:user)
# 			sign_in user
# 			delete :destroy, params: { id: 'shakalaka' }
# 			expect(response).to have_http_status(:not_found)
# 		end
# 	end
#
# end
