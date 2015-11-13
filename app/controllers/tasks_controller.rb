class TasksController < ApplicationController

  def new
    @form = TaskForm.new
  end

  def create
    @form = TaskForm.new(params[:task_form])
    user = current_user
    task = user.create_task(@form.title, @form.description)
    task.save
    redirect_to home_url
  end

  def show
    @task = Task.find(params[:id])
  end
end
