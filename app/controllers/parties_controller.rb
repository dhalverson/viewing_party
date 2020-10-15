class PartiesController < ApplicationController
  before_action :require_user

  def new
    response = conn.get("3/movie/#{params[:movie_id]}?api_key=#{movies_api_key}")
    @movie = JSON.parse(response.body, symbolize_names: true)
    @party = Party.new
  end

  def create
    movie = set_movie(party_params[:movie_id], params[:party][:movie_title])
    party = Party.create(party_params)
    if party.save
      valid_party(party)
      party.invite(invited_users) if invited_users && invited_users.size > 1
    else
      invalid_party(party, movie.id)
    end
  end

  private

  def party_params
    params.require(:party).permit(:duration, :party_date, :start_time, :movie_id, :party_users)
  end

  def invited_users
    params[:party][:party_users]
  end
  # COMMENT: seems like a good candidate for a Service class. Looks like MovieService already uses this conn
  def conn
    Faraday.new(url: 'https://api.themoviedb.org')
  end

  def movies_api_key
    ENV['MOVIES_API_KEY']
  end

  def valid_party(party)
    party.party_users.create(user_id: current_user.id, attendee_type: 0)
    redirect_to dashboard_path
  end

  def invalid_party(party, movie_id)
    flash[:error] = party.errors.full_messages.to_sentence
    redirect_to new_party_path(movie_id: movie_id)
  end

  def set_movie(movie_id, title)
    if Movie.exists?(movie_id)
      Movie.find(movie_id)
    else
      Movie.create(id: movie_id, title: title)
    end
  end
end
