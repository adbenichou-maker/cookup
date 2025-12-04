class ReviewsController < ApplicationController

  def new
    @recipe = Recipe.find(params[:recipe_id])
    @review = Review.new
  end


  def create
    @recipe = Recipe.find(params[:recipe_id])

    # Create the review with strong parameters and associate it with the recipe
    @review = @recipe.reviews.new(review_params)

    if @review.save
      flash[:notice] = "Thank you for your review! We've recorded your rating."

      # 👇 CHANGE MADE HERE 👇
      # Redirect to the custom congratulation route, which requires the recipe object/ID
      redirect_to congratulation_recipe_path(@recipe)

    else
      flash.now[:alert] = "Could not save review. Please check the fields below."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:title, :comment, :rate)
  end

end
