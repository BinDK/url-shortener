class UrlsController < ApplicationController
  def encode
    url_encoder = UrlEncoder.new(params[:url])
    url = url_encoder.call

    render json: { result: url.encoded_url }, status: :created if url
  end

  def decode
    short_code = params[:url].split('/').last
    url = Url.find_by!(short_code:)

    render json: { url: url.original_url } if url
  end
end
