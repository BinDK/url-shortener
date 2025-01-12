require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  let(:original_url) { 'http://example.com' }

  describe 'POST #encode' do
    context 'with valid URL' do
      it 'returns the encoded URL' do
        post :encode, params: { url: original_url }

        short_url = Url.last.encoded_url
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['result']).to eq(short_url)
      end
    end

    context 'with invalid URL' do
      it 'returns an error' do
        post :encode, params: { url: '' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when retry limit is reached in UrlEncoder service' do
      before do
        allow(Url).to receive(:exists?).and_return(true)
      end

      it 'should returns a bad_request status with message.' do
        post :encode, params: { url: original_url }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['message']).to eq('Please try again later.')
      end
    end
  end

  describe 'GET #decode' do
    before { UrlEncoder.new(original_url).call }

    context 'with valid short code' do
      it 'returns the original URL' do
        short_url = Url.last.encoded_url

        get :decode, params: { url: short_url }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['result']).to eq(original_url)
      end
    end

    context 'when user input invalid short url' do
      let(:url) { "#{ENV.fetch('BASE_URL')}/example" }

      it 'should return status not_found' do
        get :decode, params: { url: }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
