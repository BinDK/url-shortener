class UrlEncoder
  CONFUSING_CHARS = %w[I 0 l i l o].freeze
  DEFAULT_RETRY_LIMIT = ENV.fetch('RETRY_LIMIT', 3).to_i
  DEFAULT_SHORT_CODE_LENGTH = ENV.fetch('SHORT_CODE_LENGTH', 4).to_i
  CHARSETS = (('a'..'z').to_a + ('A'..'Z').to_a + (1..9).to_a - CONFUSING_CHARS).freeze

  def initialize(original_url)
    @original_url = original_url
  end

  def call
    encoded_url = Url.new(original_url:)
    encoded_url.short_code = generate_unique_short_code
    encoded_url.save!
    encoded_url
  end

  private

  attr_reader :original_url

  def generate_unique_short_code
    retry_count = 0

    loop do
      short_code = DEFAULT_SHORT_CODE_LENGTH.times.map { CHARSETS.sample }.join
      return short_code unless Url.exists?(short_code:)

      retry_count += 1
      raise ServiceException, 'Please try again later.' if retry_count >= DEFAULT_RETRY_LIMIT
    end
  end
end
