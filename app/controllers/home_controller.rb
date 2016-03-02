class HomeController < ApplicationController
  before_action :authorize!

  def index
    @tasks = TaskRepository.all_uncompleted_by_assignee(current_user.id).map do |task|
      TaskPresenter.create(task)
    end
  end
end
