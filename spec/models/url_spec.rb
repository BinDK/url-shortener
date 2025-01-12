require 'rails_helper'

RSpec.describe Url, type: :model do
  let(:url) { Url.new(original_url: 'http://example.com', short_code: 'abcd') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(url).to be_valid
    end

    it 'is not valid without an original_url' do
      url.original_url = nil
      expect(url).not_to be_valid
    end

    it 'is not valid without a short_code' do
      url.short_code = nil
      expect(url).not_to be_valid
    end

    it 'is not valid with a duplicate short_code' do
      Url.create!(original_url: 'http://example.com', short_code: 'abcd')
      expect(url).not_to be_valid
    end
  end

  describe '#encoded_url' do
    it 'returns the full encoded URL' do
      expect(url.encoded_url).to eq("#{ENV.fetch('BASE_URL')}/abcd")
    end
  end
end
