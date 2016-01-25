class HomeController < ApplicationController
  before_action :authorize!

  def index
    tasks = TaskRepository.all_uncompleted_by_assignee(current_user.id).map do |task|
      TaskPresenter.new(task)
    end
    tasks.group_by { |t| t.todays_task_for_user?(current_user.id) }.tap do |group|
      @todays_tasks = Array(group[true])
      @somedays_tasks = Array(group[false])
    end
  end

  def create_todays_task
    old_todays_tasks = TodaysTask.where(user_id: current_user.id)
    todays_tasks = TodaysTaskList.new(current_user.id, old_todays_tasks)
    todays_tasks.add_task(params[:task_id])
    todays_tasks.save
    redirect_to root_url
  end

  def destroy_todays_task
    old_todays_tasks = TodaysTask.where(user_id: current_user.id)
    todays_tasks = TodaysTaskList.new(current_user.id, old_todays_tasks)
    todays_tasks.remove_task(params[:task_id].to_i)
    todays_tasks.save
    redirect_to root_url
  end
end
