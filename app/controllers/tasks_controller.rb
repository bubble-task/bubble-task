class TasksController < ApplicationController
  before_action :authorize!

  def index
    @tag = params[:tag]
    @tasks = TaskRepository.all_by_tag(@tag)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @command = TaskCreation.new
  end

  def create
    @command = TaskCreation.new(params[:task_creation])
    if @command.run(current_user)
      redirect_to root_url, notice: I18n.t('.activemodel.messages.task_creation.success')
    else
      render :new
    end
  end

  def edit
    task = TaskRepository.find_by_id(params[:id])
    @command = TaskEditing.from_task(task)
  end
end
