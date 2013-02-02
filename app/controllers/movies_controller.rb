class MoviesController < ApplicationController

  def index
    if @all_ratings.nil?
      @all_ratings = Movie.select(:rating).map(&:rating).uniq
    end
    
    if params[:sort].eql?("title")
      flash[:notice] = 'title'
      @movies = Movie.where(:rating => params[:filter]).find(:all,:order => "title")
      @checks = params[:filter]
    elsif params[:sort].eql?("rdate") 
      flash[:notice] = 'release_date'
      @movies = Movie.where(:rating => params[:filter]).find(:all,:order => "release_date")
      @checks = params[:filter]
    else
      if params[:ratings]
        @movies = Movie.where(:rating => params[:ratings].keys)
	@checks = params[:ratings].keys
      else
	@movies = Movie.all
      end
      flash[:notice] = nil
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

