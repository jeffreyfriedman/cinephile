class ReviewsController < ApplicationController
  before_action :authorize_user, except: [:index]
  before_action :set_ratings

  def create
    @review = Review.new(review_params)
    @movie = Movie.find(params[:movie_id])
    review = Review.find_by(user: current_user, movie: @movie)
    @review.movie = @movie
    @review.user = current_user
    if !review.nil?
      flash[:notice] = "User can only submit one review per movie"
      redirect_to movie_path(@movie)
    elsif @review.save
      UserMailer.notice(@review).deliver
      flash[:notice] = "Review Submitted!"
      redirect_to movie_path(@movie)
    else
      fail_create(@review)
    end
  end

  def edit
    @review = Review.find(params[:id])
    @movie = @review.movie
  end

  def update
    @review = Review.find(params[:id])
    @movie = Movie.find(params[:movie_id])
    @review.update_attributes(review_params)
    if @review.save
      flash[:notice] = "Review successfully updated!"
      redirect_to movie_path(@movie)
    else
      fail_update(@review)
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    flash[:notice] = "Review Deleted!"
    redirect_to movie_path(params[:movie_id])
  end

  private

  def review_params
    params.require(:review).permit(:title, :body, :rating)
  end

  protected

  def authorize_user
    unless user_signed_in?
      flash[:notice] = "Please sign in or sign up in"\
      " order to view this movie and its reviews"
      redirect_to root_path
    end
  end

  private

  def review_params
    params.require(:review).permit(
      :title,
      :body,
      :rating,
      :movie_id,
      :user_id
    )
  end

  def set_ratings
    @ratings = Movie::RATINGS
  end

  def fail_create(obj)
    @errors = obj.errors.full_messages.join(", ")
    flash[:notice] = "Review failed to submit: " + @errors
    render :"movies/show"
  end

  def fail_update(obj)
    flash[:notice] = "Review was not updated."
    @errors = obj.errors.full_messages.join(", ")
    flash[:alert] = @errors
    render action: "edit"
  end
end
