require 'rails_helper'

describe Restaurant, type: :model do
  it { is_expected.to have_many(:reviews).dependent(:destroy) }

  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: 'kf')
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it 'is not valid unless it has a unique name' do
    Restaurant.create(name: "Moe's Tavern")
    restaurant = Restaurant.new(name: "Moe's Tavern")
    expect(restaurant).to have(1).error_on(:name)
  end

  describe '#avarage_rating' do
    context 'no reviews' do
      it 'returns "N/A" when there are no reviews' do
        restaurant = Restaurant.create(name: 'KFC')
        expect(restaurant.average_rating).to eq 'N/A'
      end
    end

    context 'one review' do
      it 'returns the only rating present' do
        restaurant = Restaurant.create(name: 'KFC')
        restaurant.reviews.create(rating: 5)
        expect(restaurant.average_rating).to eq 5
      end
    end

    context 'multiple reviews' do
      it 'returns the avarage' do
        restaurant = Restaurant.create(name: 'KFC')
        restaurant.reviews.new(rating: 5).save(validate: false)
        restaurant.reviews.new(rating: 1).save(validate: false)
        expect(restaurant.average_rating).to eq 3
      end
    end
  end
end
