require 'rails_helper'

RSpec.describe RedirectsController, type: :controller do
  describe 'GET /show' do
    let(:original_url) { 'http://example.com' }
    let(:short_code) { 'abcd' }
    let!(:url) { Url.create!(original_url:, short_code:) }

    context 'when the short code exists' do
      it 'should redirects to the original URL' do
        get :show, params: { short_code: }
        expect(response).to redirect_to(original_url)
      end
    end

    context 'when shortened url is invalid' do
      it 'should return invlaid URL message' do
        get :show, params: { short_code: 'nonexistent' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
