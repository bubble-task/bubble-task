class TasksController < ApplicationController

  def new
    @command = TaskCreation.new
  end

  def create
    @command = TaskCreation.new(params[:task_creation])
    if @command.run(current_user)
      redirect_to home_url, notice: I18n.t('.activemodel.messages.task_creation.success')
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
  end
end
