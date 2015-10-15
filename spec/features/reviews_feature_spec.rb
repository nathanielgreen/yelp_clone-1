require 'rails_helper'

feature 'reviewing' do
  before do
    sign_up
    add_place
  end

	scenario 'allows users to leave a review using a form' do
		visit '/restaurants'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so so"
		select '3', from: 'Rating'
		click_button 'Leave Review'

		expect(current_path).to eq '/restaurants'
		expect(page).to have_content('so so')
	end
  scenario 'user cannot leave more than one review' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "bad"
    select '2', from: 'Rating'
    click_button 'Leave Review'
    expect(page).not_to have_content('bad')
  end
end

describe 'reviews' do
  describe 'build_with_user' do
    
    let(:user) { User.create email: 'test@test.com' }
    let(:restaurant) { Restaurant.create name: 'Test' }
    let(:review_params) { {rating: 5, thoughts: 'yum'} }

    subject(:review) { restaurant.reviews.build_with_user(review_params, user) }

    it 'builds a review' do
      expect(review).to be_a Review
    end

    it 'builds a review associated with the specified user' do
      expect(review.user).to eq user
    end
  end
end



def sign_up
	visit('/')
	click_link('Sign up')
	fill_in('Email', with: 'test@example.com')
	fill_in('Password', with: 'testtest')
	fill_in('Password confirmation', with: 'testtest')
	click_button('Sign up')
end

def add_place
  visit('/restaurants')
  click_link('Add a restaurant')
  fill_in('Name', with: 'KFC')
  click_button('Create Restaurant')
end
