class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |_e|
    render json: { error: 'Invalid URL' }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  rescue_from ServiceException do |e|
    render json: { message: e.message }, status: :bad_request
  end
end
