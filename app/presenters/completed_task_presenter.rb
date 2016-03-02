class CompletedTaskPresenter < SimpleDelegator

  def initialize(task)
    super(task)
  end

  def tags
    TagPresenter.create(__getobj__.tags)
  end

  def completion_command
    TaskCompletion.new(task_id: id)
  end

  def cancellation_completion_command
    TaskCancellationCompletion.new(task_id: id)
  end

  def signed_up?(user)
    assignees.include?(user)
  end

  def completed_on
    completed_task.completed_at.to_date
  end

  def completion_checkbox_state
    %(checked="checked").html_safe
  end

  def show_deadline
    return unless deadline
    I18n.l(deadline, format: :short)
  end
end
