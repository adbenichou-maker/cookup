class ReviewsController < ApplicationController

  def new
    @recipe = Recipe.find(params[:recipe_id])
    @review = Review.new
  end


  def create
    @recipe = Recipe.find(params[:recipe_id])
    @review = @recipe.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      flash[:notice] = "Thank you for your review!"
      redirect_to congratulation_recipe_path(@recipe)
    else
      redirect_to congratulation_recipe_path(@recipe), alert: "Review not saved."
    end
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    @review = @recipe.reviews.find(params[:id])
    @review.destroy

    redirect_to recipe_path(@recipe), status: :see_other


  end


  private

  def review_params
    params.require(:review).permit(:title, :comment, :rate)
  end

end
