class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.AllRatings

    # saving the filter settings in session.
    if params[:ratings].nil? and session[:checked_ratings].nil?
      session[:checked_ratings] = @all_ratings
    elsif !params[:ratings].nil?
      session[:checked_ratings] = params[:ratings].keys
    end
    @checked_ratings = session[:checked_ratings]

    # saving the sort settings in session
    if !params[:sort].nil?
      session[:sort_order] = params[:sort]
    end
    @sort_order = session[:sort_order]

    if !@sort_order.nil?
       @movies = Movie.where('rating' => @checked_ratings).order(@sort_order).all
       @title_header = 'hilite'
    else
      @movies = Movie.where('rating' => @checked_ratings)
    end

    flash.keep

    if !session[:sort_order].nil? and !params.has_key?(:sort)
      redirect_to movies_path(:sort=>"#{@sort_order}")
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end