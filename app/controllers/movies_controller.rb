class MoviesController < ApplicationController

  def index
    if params[:sort].eql?("title")
      flash[:notice] = 'title'
      @movies = Movie.all(:order => "title")
    elsif params[:sort].eql?("rdate") 
      flash[:notice] = 'release_date'
      @movies = Movie.all(:order => "release_date")
    else
      @movies = Movie.all
    end
  end
  
  def show
    id = params[:id]
    @movie = Movie.find(id)
  end
  
  def new
    #default: render 'new' template
  end
  
  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end
end

