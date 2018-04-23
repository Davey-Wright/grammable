class GramsController < ApplicationController

	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

	def index
		@grams = Gram.all
	end

	def new
		@gram = Gram.new
	end

	def create
		@gram = current_user.grams.create(gram_params)
		if @gram.valid?
			redirect_to	root_path
		else
			render_status(:unprocessable_entity)
		end
	end

	def show
		@gram = current_gram
		render_status(:not_found) if @gram.blank?
	end

	def edit
		@gram = current_gram
		return render_status(:not_found) if @gram.blank?
		return render_status(:forbidden) if current_user != @gram.user
	end

	def update
		@gram = current_gram
		return render_status(:not_found) if @gram.blank?
		return render_status(:forbidden) if current_user != @gram.user

		@gram.update_attributes(gram_params)
		if @gram.valid?
			redirect_to grams_path(@gram)
		else
			return render_status(:unprocessable_entity)
		end
	end

	def destroy
		@gram = current_gram
		return render_status(:not_found) if @gram.blank?
		return render_status(:forbidden) if current_user != @gram.user

		@gram.destroy
		redirect_to root_path
	end

	private

	def gram_params
		params.require(:gram).permit(:message, :photo)
	end

	def render_status(err)
		render :new, status: err
	end

	def current_gram
		Gram.find_by_id(params[:id])
	end

end
