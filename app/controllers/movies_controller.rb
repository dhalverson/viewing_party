class MoviesController < ApplicationController
  before_action :require_user

  def index
    # COMMENT: boolean expressions like this are incredibly hard to read. Consider extracting hefty boolean
    # logic into descriptive helper methods. You could also consider passing params into a more generic MovieFacade
    # method, and handling all of this logic in the facade. Additionally, you could consider initializing an instance of
    # MovieFacade with params like this: movie_facade = MovieFacade.new(params)
    if params[:top_40] || !params[:top_40] && !params[:keyword_search] && !params[:trending]
      # @movies = MovieFacade.top_movies
      fetch_movies('top')
    elsif params[:trending]
      @movies = MovieFacade.trending_movies
    elsif params[:keyword_search] != ''
      # @movies = MovieFacade.keyword_search(params[:keyword_search])
      fetch_movies('search')
    else
      redirect_to discover_path
    end
  end

  def show
    @movie = MovieFacade.get_movie_details(params[:id])
  end

  def fetch_movies(request_type)
    # COMMENT: this method seems like an unnecessary level of abstration. It actually leads to more lines of code
    # than if you had just called MovieFacade directly in the index method
    if request_type == 'top'
      @movies = MovieFacade.top_movies
    else
      @movies = MovieFacade.keyword_search(params[:keyword_search])
    end
  end
end
