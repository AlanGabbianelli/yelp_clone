module ReviewsHelper
  def star_rating(rating)
    return rating unless rating.is_a?(Fixnum) || rating.is_a?(Float)
    '★' * rating.round + '☆' * (5 - rating)
  end
end
