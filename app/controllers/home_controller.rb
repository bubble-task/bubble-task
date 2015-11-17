class HomeController < ApplicationController
  before_action :authorize!

  def index
    @tasks = Task.where(author_id: current_user.id)
  end
end
