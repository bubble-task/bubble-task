class TasksController < ApplicationController

  def new
    @form = TaskForm.new
  end

  def create
    @form = TaskForm.new(params[:task_form])
    render text: @form.title
  end
end
