class SessionsController < ApplicationController
  layout 'sign_in'

  def new
    redirect_to root_url if signed_in?
  end
end
