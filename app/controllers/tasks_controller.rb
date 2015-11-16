class TasksController < ApplicationController

  def new
    @form = TaskForm.new
  end

  def create
    @form = TaskForm.new(params[:task_form])
    user = current_user
    if @form.valid?
      task = user.create_task(@form.title, @form.description)
      task.save
      redirect_to home_url
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
  end
end
