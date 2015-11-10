class OauthCallbacksController < ApplicationController
  def create
    redirect_to home_url
  end
end
