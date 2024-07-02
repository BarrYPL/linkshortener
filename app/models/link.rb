class Link < ApplicationRecord
  belongs_to :user, optional: true

  validates :url, presence: true
  validates :visits, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :category, presence: true, on: :update

  before_create :generate_short_url
  before_validation :set_default_visits

  private

  def generate_short_url
    newid = Link.last ? Link.last.id + 1 : 1
    self.url_short = Base64.encode64(newid.to_s).strip
  end

  def set_default_visits
    self.visits ||= 0
  end
end