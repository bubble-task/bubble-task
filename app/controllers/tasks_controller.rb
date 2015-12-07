class TasksController < ApplicationController
  before_action :authorize!

  def index
    @tag = params[:tag]
    @tasks = TaskRepository.all_by_tag(@tag).map do |task|
      TaskPresenter.new(task)
    end
  end

  def show
    @task = TaskPresenter.new(task)
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
    @command = TaskEditing.from_origin(task)
  end

  def update
    @command = TaskEditing.new(task, TaskParameters.new(params[:task_parameters]))
    if @command.run
      redirect_to root_url, notice: I18n.t('.activemodel.messages.task_editing.success')
    else
      render :edit
    end
  end

  def complete
    command = TaskCompletion.new(task_id: params[:id])
    command.run
    @task = TaskPresenter.new(command.result)
  end

  def destroy
    TaskDeletion.new(task_id: params[:id]).run
    respond_to do |f|
      f.html { redirect_to root_path, notice: I18n.t('activemodel.messages.task_deletion.success') }
      f.js { render 'destroy' }
    end
  end

  private

    def task
      @_task ||= TaskRepository.find_by_id(params[:id])
    end
end
