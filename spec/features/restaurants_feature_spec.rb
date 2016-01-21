require 'rails_helper'

feature 'Restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end

    context 'creating restaurants' do
      context 'when user is signed up' do
        before { user_sign_up }

        scenario 'prompts user to fill a form, then displays new restaurant' do
          visit '/restaurants'
          click_link 'Add a restaurant'
          fill_in 'Name', with: 'KFC'
          click_button 'Create Restaurant'
          expect(page).to have_content 'KFC'
          expect(current_path).to eq '/restaurants'
        end

        context 'an invalid restaurant' do
          scenario 'does not let user submit a name that is too short' do
            visit '/restaurants'
            click_link 'Add a restaurant'
            fill_in 'Name', with: 'kf'
            click_button 'Create Restaurant'
            expect(page).not_to have_css 'h2', text: 'kf'
            expect(page).to have_content 'error'
          end

          scenario 'does not let user submit a name that is already present' do
            add_kfc
            add_kfc
            expect(page).not_to have_css 'h2', text: 'KFC'
            expect(page).to have_content 'error'
          end
        end
      end
      context 'when user is not signed up' do
        scenario 'does not let user create a restaurant' do
          visit '/restaurants'
          click_link 'Add a restaurant'
          expect(page).not_to have_content 'Create Restaurant'
          expect(page).to have_content 'Log in'
          expect(current_path).to eq '/users/sign_in'
        end
      end
    end
  end

  context 'restaurants have been added' do
    let!(:kfc) { Restaurant.create(name: 'KFC') }

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content 'KFC'
      expect(page).not_to have_content 'No restaurants yet'
    end

    context 'viewing restaurants' do
      scenario 'lets a user view a restaurant' do
        visit '/restaurants'
        click_link 'KFC'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq "/restaurants/#{kfc.id}"
      end
    end

    context 'editing / deleting restaurants' do
      before { user_sign_up }

      scenario 'let a user edit a restaurant' do
        visit '/restaurants'
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(current_path).to eq '/restaurants'
      end

      scenario 'removes a restaurant when a user clicks delete link' do
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurants deleted successfully'
      end
    end
  end
end
