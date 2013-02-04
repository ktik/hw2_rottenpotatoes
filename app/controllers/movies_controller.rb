class MoviesController < ApplicationController

  def index
    check_for_redirect

    if @all_ratings.nil?
      @all_ratings = Movie.select(:rating).map(&:rating).uniq
    end

    if params[:sort].eql?("title") #user is sorting by title
      flash[:notice] = 'title'
      (session[:rating]==nil)? @movies = Movie.find(:all,:order => "title") : @movies = Movie.where(:rating => session[:rating].keys).find(:all,:order => "title")
      @checks = session[:rating]
      flash.keep
    elsif params[:sort].eql?("release_date") #user is sorting by release date
      flash[:notice] = 'release_date'
      (session[:rating]==nil)? @movies = Movie.find(:all,:order => "release_date") : @movies = Movie.where(:rating => session[:rating].keys).find(:all,:order => "release_date")
      @checks = session[:rating]
      flash.keep
    elsif params[:ratings]		#user is refreshing the ratings
      session[:rating] = params[:ratings]
      if session[:sort]!=nil
        @movies = Movie.where(:rating => session[:rating].keys).find(:all,:order => session[:sort])
	@checks = session[:rating]
	
      else
	@movies = Movie.where(:rating => session[:rating].keys)
	@checks = session[:rating]
	
      end
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
  
  private
  def check_for_redirect
    if params[:sort] != session[:sort] or params[:ratings] != session[:rating]
      redirect_needed = true
    end
    session[:sort] = params[:sort] unless params[:sort].nil?
    session[:rating] = params[:ratings] unless params[:ratings].nil?
    redirect_to movies_path(:sort => session[:sort],:ratings => session[:rating]) if redirect_needed
    
  end


end

