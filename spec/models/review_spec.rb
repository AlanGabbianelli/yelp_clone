require 'rails_helper'

describe Review, type: :model do
  it { is_expected.to have_many(:endorsements).dependent(:destroy) }

  it 'is invalid if the rating is more than 5' do
    review = Review.new(rating: 6)
    expect(review).to have(1).error_on(:rating)
  end

  it 'is invalid if the rating is less than 1' do
    review = Review.new(rating: 0)
    expect(review).to have(1).error_on(:rating)
  end
end
