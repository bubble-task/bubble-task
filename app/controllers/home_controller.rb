class HomeController < ApplicationController
  before_action :authorize!

  def index
    tasks = TaskRepository.all_uncompleted_by_assignee(current_user.id).map do |task|
      TaskPresenter.new(task)
    end
    tasks.group_by { |t| t.todays_task.present? }.tap do |group|
      @todays_tasks = Array(group[true])
      @somedays_tasks = Array(group[false])
    end
  end

  def create_todays_task
    todays_tasks = TodaysTaskList.new(current_user.id)
    todays_tasks.add_task(params[:task_id])
    todays_tasks.save
    redirect_to root_url
  end
end
