require 'rails_helper'

RSpec.describe UrlEncoder, type: :service do
  subject { described_class.new(original_url).call }

  let(:original_url) { 'http://example.com' }

  describe '#call' do
    context 'when a unique short code is generated' do
      it 'creates a new Url record with the original URL and short code' do
        expect { subject }.to change { Url.count }.by(1)
        expect(subject.original_url).to eq(original_url)
        expect(subject.short_code).not_to be_nil
      end
    end

    context 'when the short code already exists' do
      before do
        allow(Url).to receive(:exists?).and_return(true, false)
      end

      it 'should retries until a unique short code is generated' do
        expect { subject }.to change { Url.count }.by(1)
        expect(subject.original_url).to eq(original_url)
        expect(subject.short_code).not_to be_nil
      end
    end

    context 'when the retry limit is reached' do
      before do
        allow(Url).to receive(:exists?).and_return(true)
      end

      it 'should raises a ServiceException' do
        expect { subject }.to raise_error(ServiceException, 'Please try again later.')
      end
    end
  end
end
