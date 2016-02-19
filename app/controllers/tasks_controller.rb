class TasksController < ApplicationController
  include PathFilter

  before_action :authorize!

  def index
    @tag = params[:tag]
    @tasks = TaskRepository.all_by_tag(@tag).map do |task|
      TaskPresenter.new(task)
    end
  end

  def show
    @task = TaskPresenter.new(TaskRepository.find_by_id(params[:id]))
  end

  def new
    @form = TaskCreationForm.new(tag_words: params[:tag])
  end

  def create
    command = TaskCreation.new(TaskCreationForm.new(params[:task_parameters]))
    if command.run(current_user)
      p ooooooo:Task.last.deadline
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
    if command.run(current_user)
      redirect_to root_url, notice: I18n.t('.activemodel.messages.task_editing.success')
    else
      @form = command.form
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

  def cancel_completion
    @task = TaskPresenter.new(Task.find(params[:id]))
    TaskCancellationCompletion.new(@task).run
    redirect_to filter_for_search(referer_path), notice: I18n.t('activemodel.messages.task_cancellation_completion.success')
  end

  private

    def referer_path
      "#{URI(request.referer).path}?#{URI(request.referer).query}"
    end
end
