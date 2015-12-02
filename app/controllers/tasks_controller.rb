class TasksController < ApplicationController
  before_action :authorize!

  def index
    @tag = params[:tag]
    @tasks = TaskRepository.all_by_tag(@tag).map do |task|
      TaskPresenter.new(task)
    end
  end

  def show
    @task = TaskPresenter.new(Task.find(params[:id]))
  end

  def new
    @command = TaskCreation.new(TaskParameters.new)
  end

  def create
    @command = TaskCreation.new(TaskParameters.new(params[:task_parameters]))
    if @command.run(current_user)
      redirect_to root_url, notice: I18n.t('.activemodel.messages.task_creation.success')
    else
      render :new
    end
  end

  def edit
    task = TaskRepository.find_by_id(params[:id])
    @command = TaskEditing.from_origin(task)
  end

  def update
    task = TaskRepository.find_by_id(params[:id])
    @command = TaskEditing.new(task, TaskParameters.new(params[:task_parameters]))
    if @command.run
      redirect_to root_url, notice: I18n.t('.activemodel.messages.task_editing.success')
    else
      render :edit
    end
  end

  def complete
    task = Task.find(params[:id])
    TaskCompletion.new(task: task).run
    redirect_to root_url
  end
end
