class SessionsController < ApplicationController
  layout 'sign_in'

  def new
    if signed_in?
      redirect_to root_url
    end
  end
end
