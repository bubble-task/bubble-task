class AssignmentsController < ApplicationController
  before_action :authorize!

  def create
    task = TaskRepository.find_by_id(params[:task_id])
    command = TaskAssignment.new(task: task, assignee: current_user)
    command.run
    @task = TaskPresenter.new(task)
  end
end
