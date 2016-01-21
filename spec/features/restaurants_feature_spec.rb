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
        before { user_1_sign_up }

        scenario 'prompts user to fill a form, then displays new restaurant' do
          add_kfc
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
      scenario 'let a user edit a restaurant' do
        user_1_sign_up
        add_negril
        click_link 'Edit Negril'
        fill_in 'Name', with: 'New Negril'
        click_button 'Update Restaurant'
        expect(page).to have_content 'New Negril'
        expect(current_path).to eq '/restaurants'
      end

      scenario 'let a user delete a restaurant' do
        user_1_sign_up
        add_negril
        click_link 'Delete Negril'
        expect(page).not_to have_content 'Negril'
        expect(page).to have_content 'Restaurants deleted successfully'
      end

      scenario 'let a user edit only restaurants they created' do
        user_1_sign_up
        add_kfc
        click_link 'Sign out'
        user_2_sign_up
        click_link 'Edit KFC'
        expect(page).to have_content 'You cannot edit a restaurant created by someone else'
      end

      scenario 'let a user delete only restaurants they created' do
        user_1_sign_up
        add_kfc
        click_link 'Sign out'
        user_2_sign_up
        click_link 'Delete KFC'
        expect(page).to have_content 'You cannot delete a restaurant created by someone else'
      end
    end
  end
end
