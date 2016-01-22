require 'rails_helper'

feature 'Reviewing' do
  before { user_1_sign_up ; add_kfc }

  scenario 'let a user leave a review using a form' do
    add_good_kfc_review
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content 'good'
  end

  scenario 'let a user leave only one review per restaurant' do
    add_good_kfc_review
    add_bad_kfc_review
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content 'good'
    expect(page).not_to have_content 'bad'
    expect(page).to have_content 'You cannot review a restaurant more than once'
  end

  scenario 'let a user delete only reviews they created' do
    add_good_kfc_review
    click_link 'Delete review'
    expect(page).to have_content 'Review deleted successfully'
    add_bad_kfc_review
    click_link 'Sign out'
    user_2_sign_up
    click_link 'Delete review'
    expect(page).not_to have_content 'Review deleted successfully'
    expect(page).to have_content 'You cannot delete a review created by someone else'
  end

  scenario 'displays an average rating for the reviews' do
    expect(page).to have_content 'No reviews.'
    add_good_kfc_review
    expect(page).to have_content 'Average rating: ★★★★★'
    click_link 'Sign out'
    user_2_sign_up
    add_bad_kfc_review
    expect(page).to have_content 'Average rating: ★★★☆☆'
  end
end
