class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    if params[:ratings].kind_of?(Hash)
      params[:ratings] = params[:ratings].keys
    end
    
    if params[:ratings] != nil
      @ratings = params[:ratings]
    elsif session[:ratings] != nil
      @ratings = session[:ratings]
    else 
      @ratings = @all_ratings

    @sort = params[:sort] || session[:sort] || nil
    
    if params[:sort] != session[:sort] || params[:ratings] != session[:ratings]
      session[:ratings] = @ratings
      session[:sort] = @sort
      
      flash.keep
      redirect_to :sort => @sort, :ratings => @ratings and return
    end

    @movies = Movie.where(rating: @ratings)

    if @sort == "release"
      @release_hilite = "hilite"
      @movies = Movie.where(rating: @ratings).order("release_date")
    else
      @release_hilite = ""
    end
    
    if @sort == "title"
      @title_hilite = "hilite"
      @movies = Movie.where(rating: @ratings).order("title")
    else
      @title_hilite = ""
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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