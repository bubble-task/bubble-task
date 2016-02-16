class HomeController < ApplicationController
  before_action :authorize!

  def index
    @tasks = TaskRepository.all_uncompleted_by_assignee(current_user.id).map do |task|
      TaskPresenter.new(task)
    end
  end

  def create_todays_task
    #todays_tasks = TodaysTaskList.load(current_user.id)
    #TaskScheduling.new(params[:task_id], todays_tasks).run
    redirect_to root_url
  end

  def destroy_todays_task
    #todays_tasks = TodaysTaskList.load(current_user.id)
    #TaskCancellationScheduling.new(params[:task_id], todays_tasks).run
    redirect_to root_url
  end
end
