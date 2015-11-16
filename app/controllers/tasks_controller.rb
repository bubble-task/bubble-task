class TasksController < ApplicationController

  def new
    @form = TaskForm.new
  end

  def create
    @form = TaskForm.new(params[:task_form])
    if @form.create_task(current_user)
      redirect_to home_url
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
  end
end
