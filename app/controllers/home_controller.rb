class HomeController < ApplicationController
  before_action :authorize!

  def index
    @tasks = TaskRepository.all_uncompleted_by_author_id(current_user.id).map do |task|
      TaskPresenter.new(task)
    end
  end
end
