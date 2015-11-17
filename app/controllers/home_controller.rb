class HomeController < ApplicationController
  before_action :authorize!

  def index
    @tasks = Task.by_author(current_user)
  end
end
