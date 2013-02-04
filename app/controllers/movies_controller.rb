class MoviesController < ApplicationController

  def index
    if @all_ratings.nil?
      @all_ratings = Movie.select(:rating).map(&:rating).uniq
    end
    if params[:ratings]==nil and params[:sort]==nil and params[:filter]==nil and session!=nil
      @movies = Movie.where(:rating => session[:rating]).find(:all,:order => session[:sort])
      @checks = session[:rating]
      flash[:notice] = session[:sort]
      flash.keep
    end
    if params[:sort].eql?("title") 
      flash[:notice] = 'title'
      session[:sort] = "title"
      session[:rating] = params[:filter]
      @movies = Movie.where(:rating => session[:rating]).find(:all,:order => "title")
      @checks = session[:rating]
      flash.keep
    elsif params[:sort].eql?("release_date") 
      flash[:notice] = 'release_date'
      session[:sort] = "release_date"
      session[:rating] = params[:filter]
      @movies = Movie.where(:rating => session[:rating]).find(:all,:order => "release_date")
      @checks = session[:rating]
      flash.keep
    elsif params[:ratings]
      session[:rating] = params[:ratings].keys
      if session[:sort]!=nil
        @movies = Movie.where(:rating => session[:rating]).find(:all,:order => session[:sort])
      else
	@movies = Movie.where(:rating => session[:rating])
      end
	@checks = session[:rating]
    else
      if session[:rating]!=nil and session[:sort]!=nil
        @movies = Movie.where(:rating => session[:rating]).find(:all,:order => session[:sort])
	rediret_to movies_path(session)
      elsif session[:rating]!=nil and session[:sort]==nil
        @movies = Movie.where(:rating => session[:rating])
      else
        @movies = Movie.all
      end
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

