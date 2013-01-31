class MoviesController < ApplicationController

  def index
    if params[:sort].eql?("title")
      @movies = Movie.find(:all, :order => "title DESC")
      flash[:notice] = 'title'
    elsif params[:sort].eql?("rdate") 
      @movies = Movie.find(:all, :order => "release_date DESC")
      flash[:notice] = 'release_date'
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

