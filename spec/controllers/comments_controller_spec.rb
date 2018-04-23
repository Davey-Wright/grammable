require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "comments#create action" do
    it "Should allow users to create a comment" do
      gram = FactoryBot.create(:gram)
      comment_count = gram.comments.count
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: {
        gram_id: gram.id,
        comment: { message: 'sugar'}
      }
      expect(response).to redirect_to gram_path(gram.id)

      gram.reload
      expect(gram.comments.count).to eq(comment_count + 1)
      expect(gram.comments.last.message).to eq('sugar')

    end

    it "Should require a user be logged into the app to make a comment" do
      gram = FactoryBot.create(:gram)
      post :create, params: {
        gram_id: gram.id,
        comment: { message: 'sugar'}
      }
      expect(response).to redirect_to new_user_session_path
    end

    it "Should return a not found status code if the gram is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      
      post :create, params: {
        gram_id: 'booooooom ting ling',
        comment: {
          message: 'awesome gram'
        }
      }
      expect(response).to have_http_status(:not_found)
    end
  end
end
