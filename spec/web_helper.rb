def user_1_sign_up
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: 'first-test@example.com')
  fill_in('Password', with: 'testtest')
  fill_in('Password confirmation', with: 'testtest')
  click_button('Sign up')
end

def user_2_sign_up
  visit('/')
  click_link('Sign up')
  fill_in('Email', with: 'second-test@example.com')
  fill_in('Password', with: 'testtest')
  fill_in('Password confirmation', with: 'testtest')
  click_button('Sign up')
end

def add_kfc
  visit '/restaurants'
  click_link 'Add a restaurant'
  fill_in 'Name', with: 'KFC'
  click_button 'Create Restaurant'
end

def add_negril
  visit '/restaurants'
  click_link 'Add a restaurant'
  fill_in 'Name', with: 'Negril'
  click_button 'Create Restaurant'
end

def add_bad_kfc_review
  visit '/restaurants'
  click_link 'Review KFC'
  fill_in 'Thoughts', with: 'bad'
  select '1', from: 'Rating'
  click_button 'Leave Review'
end

def add_good_kfc_review
  visit '/restaurants'
  click_link 'Review KFC'
  fill_in 'Thoughts', with: 'good'
  select '5', from: 'Rating'
  click_button 'Leave Review'
end
