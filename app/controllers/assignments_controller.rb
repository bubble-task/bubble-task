class AssignmentsController < ApplicationController
  before_action :authorize!

  def create
    task = TaskRepository.find_by_id(params[:task_id])
    command = TaskAssignment.new(task_id: task.id, assignee_id: current_user.id)
    command.run
    @task = TaskPresenter.new(task)
  end

  def destroy
    task = TaskRepository.find_by_id(params[:task_id])
    command = TaskCancellationAssignment.new(task_id: task.id, assignee_id: current_user.id)
    command.run
    @task = TaskPresenter.new(task)
    redirect_to task_url(@task), notice: I18n.t('activemodel.messages.task_cancellation_assignment.success')
  end
end
