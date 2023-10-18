require 'rails_helper'

describe 'Successful game plan' do
  before do
    @user = FactoryBot.create(:user, email: 'friend@mail.com', password: '123456', password_confirmation: '123456')
    nums = [10, 20, 30, 99]
    index = 3
    $redis.set("#{Game.game_id}_#{@user.id}", [nums, index])
    visit login_path
    fill_in 'email', with: 'friend@mail.com'
    fill_in 'password', with: '123456'
    click_button 'Sign in'
    visit new_game_path
    click_button '99'
    expect(page).to have_content 'You choose number 99'
  end

  it 'checks for correct display gameplay, if user win' do
    visit login_path
    fill_in 'email', with: 'friend@mail.com'
    fill_in 'password', with: '123456'
    click_button 'Sign in'
    visit new_game_path
    click_button 'Confirm'
    expect(page).to have_content 'You win!'
  end
end

describe 'Unlucky game plan' do
  before(:each) do
    @user = FactoryBot.create(:user, email: 'friend@mail.com', password: '123456', password_confirmation: '123456')
    nums = [10, 20, 30, 99]
    index = 3
    $redis.set("#{Game.game_id}_#{@user.id}", [nums, index])
    visit login_path
    fill_in 'email', with: 'friend@mail.com'
    fill_in 'password', with: '123456'
    click_button 'Sign in'
    visit new_game_path
    click_button '10'
    expect(page).to have_content 'You choose number 10'
  end

  it 'checks for correct display gameplay, if user lose' do
    visit login_path
    fill_in 'email', with: 'friend@mail.com'
    fill_in 'password', with: '123456'
    click_button 'Sign in'
    visit new_game_path
    click_button 'Confirm'
    expect(page).to have_content 'You lose! Correct number was 99'
  end
end
