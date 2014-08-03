require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers

feature "User signs up" do

  # Strictly speaking, the tests that check the UI 
  # (have_content, etc.) should be separate from the tests 
  # that check what we have in the DB. The reason is that 
  # you should test one thing at a time, whereas
  # by mixing the two we're testing both 
  # the business logic and the views.
  # However, let's not worry about this yet to keep the example simple.

  scenario "when being logged out" do    
   expect{ sign_up }.to change(User, :count).by (1)
   expect(page).to have_content("Welcome, peter@example.com")
   expect(User.first.email).to eq("peter@example.com")
  end

  scenario "with a password that doesn't match" do
    expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by (0)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Sorry, your passwords don't match")
  end

  scenario "with an email that is already registered" do
    expect{ sign_up }.to change(User, :count).by (1)
    expect{ sign_up }.to change(User, :count).by (0)
    expect(page).to have_content("This email is already taken")
  end

end

feature "User signs in" do

  before(:each) do
    User.create(:email => "test@test.com", 
                :password => 'test', 
                :password_confirmation => 'test')
  end

  scenario "with correct credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'test')
    expect(page).to have_content("Welcome, test@test.com")
  end

  scenario "with incorrect credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'wrong')
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end

# feature 'User signs out' do

#   before(:each) do
#     User.create(:email => "test@test.com", 
#                 :password => 'test', 
#                 :password_confirmation => 'test')
#   end

#   scenario 'while being signed in' do
#     sign_in('test@test.com', 'test')
#     click_button "Sign out"
#     expect(page).to have_content("Good bye!") # where's this go?
#     expect(page).not_to have_content("Welcome, test@test.com")
#   end

#   feature 'User forgets password' do

#   before(:each) do
#     User.create(:email => "test@test.com", 
#                 :password => 'test', 
#                 :password_confirmation => 'test')
#   end

#   scenario 'ask for password reset' do
#     visit '/sessions/new'
#     click_button "Password Reset"
#     expect(page).to have_content("Please enter email address")

#     click_button "Send reset email"

#   end

#   scenario 'asks for password reset but is not registered' do


#     expect(page).to have_content("You haven't registered yet. Please reister")

#   end

#   scenario '' do
    
#   end

# end

feature "User forgets password" do 

  before(:each) do 
    User.create(:email => "petermccarthy49@yahoo.co.uk",
          :password => 'test',
          :password_confirmation => 'test')
  end

  scenario "requests for password reset" do 
    visit '/users/reset'
    expect(page).to have_content("Forgot password?")
  end

  scenario "enters email that is not registered" do 
    visit '/users/reset'
    fill_in 'email', with: "wrongtest@test.com"
    click_on 'Reset Password'
    expect(page).to have_content("Sorry, wrongtest@test.com is not registered. Please sign up first!")
  end

  scenario "user enters right email address" do 
    visit '/users/reset'
    fill_in 'email', with: "petermccarthy49@yahoo.co.uk"
    click_on 'Reset Password'
    expect(page).to have_content("Password reset link sent to your email address")  
  end

end

feature "User resets password" do 
  before(:each) do 
  User.create(:email => "petermccarthy49@yahoo.co.uk",
        :password => 'test',
        :password_confirmation => 'test',
        :password_token => "1token")  
  end

  scenario "User resets password with token" do 
    visit "users/reset_password/1token"
    digest = User.first.password_digest
    expect(page).to have_content("Hi, please enter your new password")
    fill_in 'new_password', with: "replace"
    fill_in 'new_password_confirmation', with: "replace"
    click_on 'Update'
    expect(User.first.password_digest).not_to eq digest
  end

end

















