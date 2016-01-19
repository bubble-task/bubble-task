class HomeController < ApplicationController
  before_action :authorize!
  before_action :update_backward_path

  def index
    @tasks = TaskRepository.all_uncompleted_by_assignee(current_user.id).map do |task|
      TaskPresenter.new(task)
    end
  end
end
