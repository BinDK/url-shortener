class Url < ApplicationRecord
  validates :original_url, :short_code, presence: true
  validates :short_code, uniqueness: true

  def encoded_url
    "#{ENV.fetch('BASE_URL')}/#{short_code}"
  end
end
