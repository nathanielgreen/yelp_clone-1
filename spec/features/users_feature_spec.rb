require 'rails_helper'

feature "User can sign in and out" do
	context "user not signed in and on the homepage" do
		it "should see a 'sign in' link and a 'sign up' link" do
			visit('/')
			expect(page).to have_link('Sign in')
			expect(page).to have_link('Sign up')
		end

		it "should not see 'sign out' link" do
			visit('/')
			expect(page).not_to have_link('Sign out')
		end
	end

	context "user signed in on the homepage" do
		before do
			visit('/')
			click_link('Sign up')
			fill_in('Email', with: 'test@example.com')
			fill_in('Password', with: 'testtest')
			fill_in('Password confirmation', with: 'testtest')
			click_button('Sign up')
		end

		it "should see 'sign out' link" do
			visit('/')
			expect(page).to have_link('Sign out')
		end

		it "should not see a 'sign in' link and a 'sign up' link" do
			visit('/')
			expect(page).not_to have_link('Sign in')
			expect(page).not_to have_link('Sign up')
		end
	end
  context "user not signed in" do
    it "user must be logged in to create restaurants" do
      visit('/restaurants')
      click_link('Add a restaurant')
      expect(current_path).to eq '/users/sign_in'
    end
  end

  it "users cannot delete restaurants they did not create" do
  	sign_up
  	click_link('Add a restaurant')
  	fill_in 'Name', with: 'KFC'
  	click_button 'Create Restaurant'
  	click_link('Sign out')
  	sign_up(email: 'alice@example.com')
  	expect(page).not_to have_content('Delete KFC')
  end

  it "user can delete only their own reviews" do
  	sign_up
  	click_link('Add a restaurant')
  	fill_in 'Name', with: 'KFC'
  	click_button 'Create Restaurant'
		click_link 'Review KFC'
		fill_in "Thoughts", with: "so so"
		select '3', from: 'Rating'
		click_button 'Leave Review'
		click_link 'Sign out'
		expect(page).not_to have_content('Delete review')
  end
end


def sign_up(email: 'test@example.com', password: '12345678', password_confirmation: '12345678')
	visit('/')
	click_link('Sign up')
	fill_in('Email', with: email)
	fill_in('Password', with: password)
	fill_in('Password confirmation', with: password_confirmation)
	click_button('Sign up')
end  
