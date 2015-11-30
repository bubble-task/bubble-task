class HomeController < ApplicationController
  before_action :authorize!

  def index
    @tasks = TaskRepository.all_by_author_id(current_user.id)
  end
end
