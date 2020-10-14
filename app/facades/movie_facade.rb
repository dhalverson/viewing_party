class MovieFacade
  def self.top_movies_endpoint(page_num)
    sort_by = 'vote_average.desc'
    conn.get("3/discover/movie?api_key=#{movies_api_key}&#{language('en-US')}&sort_by=#{sort_by}&#{exclude_adult}&page=#{page_num}&vote_count.gte=300")
  end

  def self.keyword_search_endpoint(page_num, keywords)
    conn.get("3/search/movie?api_key=#{movies_api_key}&#{language('en-US')}&#{exclude_adult}&page=#{page_num}&query=#{keywords}")
  end

  def self.keyword_search(keywords)
    movies_pg_1 = MovieService.keyword_search(1, keywords)[:results]
    movies1 = movies_pg_1.map {|movie_data| MovieCreator.new(movie_data)} if movies_pg_1 != nil
    movies_pg_2 = MovieService.keyword_search(2, keywords)[:results]
    movies2 = movies_pg_2.map {|movie_data| MovieCreator.new(movie_data)} if movies_pg_2 != nil
    if movies1.empty? && movies2.empty?
      nil
    elsif movies2.empty?
      movies1
    else 
      movies1.concat(movies2).flatten
    end
  end

  def self.top_movies
    movies1 = MovieService.top_movies(1)[:results].map do |movie_data|
      MovieCreator.new(movie_data)
    end
    movies2 = MovieService.top_movies(2)[:results].map do |movie_data|
      MovieCreator.new(movie_data)
    end
    movies1.concat(movies2).flatten
  end

  private

  def self.language(language)
    "language=#{language}"
  end

  def self.exclude_adult
    'include_adult=false'
  end

  def self.movies_api_key
    ENV['MOVIES_API_KEY']
  end

  def self.conn
    Faraday.new(url: 'https://api.themoviedb.org')
  end

  def self.parse(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
