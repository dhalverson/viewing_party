require 'rails_helper'

RSpec.describe 'Movies detail page' do
  describe 'As an authenticated user, when I visit a movies detail page' do
    before :each do
      @user = FactoryBot.create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'I see a button to create a viewing party' do
      VCR.use_cassette('show_movie_details') do
        visit(movie_path('524'))
        expect(page).to have_button('Create Viewing Party')
      end
    end

    it 'I click create a viewing party, I am taken to the new event page' do
      VCR.use_cassette('show_movie_details') do
        visit(movie_path('524'))
        click_button('Create Viewing Party')
        expect(current_path).to eq(new_party_path)
      end
    end

    it 'I see the movies title' do
      VCR.use_cassette('show_movie_details') do
        visit(movie_path('524'))
        within '#title' do
          expect(page).to have_content('Casino')
        end
      end
    end

    it 'I see the movies user score' do
      VCR.use_cassette('show_movie_details') do
        visit(movie_path('524'))
        within '#user-score' do
          expect(page).to have_content('8.0')
        end
      end
    end

    it 'I see the movies runtime in hours and minutes' do
      VCR.use_cassette('show_movie_details') do
        visit(movie_path('524'))
        within '#runtime' do
          expect(page).to have_content('2h 59m')
        end
      end
    end

    it 'I see the movies genre(s)' do
      VCR.use_cassette('show_movie_details') do
        visit(movie_path('524'))
        within '#genres' do
          expect(page).to have_content('Crime')
        end
      end
    end

    it 'I see the summary description' do
      VCR.use_cassette('show_movie_details') do
        visit(movie_path('524'))
        within '#overview' do
          expect(page).to have_content('In early-1970s Las Vegas, low-level mobster Sam')
        end
      end
    end

    it 'I see a list of the first 10 cast members including their character and name' do
      VCR.use_cassette('show_movie_details') do
        visit(movie_path('524'))
        within '#cast' do
          expect(page).to have_content('Robert De Niro as Sam \'Ace\' Rothstein')
        end
      end
    end

    it 'I see a count of the total number of reviews' do
      VCR.use_cassette('show_movie_details') do
        visit(movie_path('278'))
        within '#reviews' do
          expect(page).to have_content('Number of Reviews:')
          expect(page).to have_content(1)
        end
      end
    end

    it 'I see for the reviews, each authors name and their information' do
      VCR.use_cassette('show_movie_details') do
        visit(movie_path('524'))
        within '#reviews' do
          expect(page).to have_content('Kris_12')
          expect(page).to have_content('https://www.themoviedb.org/review/5c51b825c3a368756484b8b4')
          expect(page).to have_content('Sharon Stone and Robert De Niro were amazing!')
        end
        click_button('Create Viewing Party')
        expect(current_path).to eq(new_party_path)
      end
    end

    it 'I see a list of other recommended movies' do
      VCR.use_cassette('show_recommendation_details') do
        visit(movie_path('524'))
        within '#recommendations' do
          expect(page).to have_content('Raging Bull')
          expect(page).to have_content('Heat')
          expect(page).to have_content('Cape Fear')
        end
      end
    end

    it 'The recommended movies are links to their respective show pages' do
      VCR.use_cassette('show_recommendation_details') do
        visit(movie_path('524'))
        within '#recommendations' do
          expect(page).to have_link('Raging Bull')
          expect(page).to have_link('Heat')
          expect(page).to have_link('Cape Fear')
        end
      end
    end
  end
end
