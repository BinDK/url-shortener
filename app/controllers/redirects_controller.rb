class RedirectsController < ApplicationController
  def show
    short_code = params[:short_code]
    url = Url.find_by!(short_code:)

    redirect_to url.original_url, allow_other_host: true
  end
end
