class TasksController < ApplicationController
  include PathFilter

  before_action :authorize!

  def index
    @tag = params[:tag]
    @tasks = TaskRepository.all_by_tag(@tag).map do |task|
      TaskPresenter.create(task)
    end
  end

  def show
    @task = TaskPresenter.create(TaskRepository.find_by_id(params[:id]))
  end

  def new
    @form = TaskCreationForm.new(tag_words: params[:tag])
  end

  def create
    command = TaskCreation.new(TaskCreationForm.new(params[:task_parameters]))
    if command.run(current_user.id)
      redirect_to root_url, notice: I18n.t('.activemodel.messages.task_creation.success')
    else
      @form = command.form
      render :new
    end
  end

  def edit
    @form = TaskEditingForm.setup_with_origin(params[:id])
  end

  def update
    task = Task.find(params[:id])
    command = TaskEditing.new(task, TaskEditingForm.new(params[:task_parameters].merge(task_id: params[:id])))
    if command.run(current_user.id)
      redirect_to root_url, notice: I18n.t('.activemodel.messages.task_editing.success')
    else
      @form = command.form
      render :edit
    end
  end

  def complete
    command = TaskCompletion.new(task_id: params[:id])
    command.run(current_user.id)
  rescue TaskCompletionNotPermitted
    render :completion_error
  else
    @task = TaskPresenter.create(command.result)
    render :completion, locals: { message: I18n.t('activemodel.messages.task_completion.success') }
  end

  def destroy
    TaskDeletion.new(task_id: params[:id]).run
    respond_to do |f|
      f.html { redirect_to root_path, notice: I18n.t('activemodel.messages.task_deletion.success') }
      f.js { render 'destroy' }
    end
  end

  def cancel_completion
    TaskCancellationCompletion.new(task_id: params[:id]).run
    @task = TaskPresenter.create(Task.find(params[:id]))
    render :completion, locals: { message: I18n.t('activemodel.messages.task_cancellation_completion.success') }
  end
end
