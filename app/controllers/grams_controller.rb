class GramsController < ApplicationController

	before_action :authenticate_user!, only: [:new, :create]

	def index
	end

	def new
		@gram = Gram.new
	end

	def create
		@gram = current_user.grams.create(gram_params)
		if @gram.valid?
			redirect_to	root_path
		else
			render_unprocessable_entity
		end
	end

	def show
		@gram = current_gram
		render_not_found if @gram.blank?
	end

	def edit
		@gram = current_gram
		render_not_found if @gram.blank?
	end

	def update
		@gram = current_gram
		return render_not_found if @gram.blank?

		@gram.update_attributes(gram_params)

		if @gram.valid?
			redirect_to grams_path(@gram)
		else
			render_unprocessable_entity
		end
	end

	def destroy
		@gram = current_gram
		if @gram.blank?
			render_not_found
		else
			@gram.destroy
			redirect_to root_path
		end
	end

	private

	def gram_params
		params.require(:gram).permit(:message)
	end

	def render_not_found
		render :new, status: :not_found
	end

	def render_unprocessable_entity
		render :new, status: :unprocessable_entity
	end

	def current_gram
		Gram.find_by_id(params[:id])
	end

end
