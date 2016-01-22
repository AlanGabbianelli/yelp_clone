require 'rails_helper'

feature 'endorsing reviews' do
  before { user_1_sign_up ; add_kfc ; add_good_kfc_review }

  scenario 'displays the number of endorsements for each review' do
    add_good_kfc_review
    expect(page).to have_content '0 endorsements'
  end

  scenario 'a user can endorse a review, which updates the review endorsement count' do
    visit '/restaurants'
    click_link 'Endorse review'
    expect(page).to have_content '1 endorsement'
  end
end
