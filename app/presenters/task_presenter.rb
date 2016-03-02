class TaskPresenter < SimpleDelegator
  class PersonalTag

    def present(_)
      %(<div class="tag-personal">#{I18n.t('tasks.show.tag_personal')}</div>).html_safe
    end
  end

  class SharedTag

    def initialize(tag)
      @tag = tag
    end

    def present(view)
      %(<div class="tag">#{view.link_to @tag, view.tasks_url(tag: @tag)}</div>).html_safe
    end
  end

  def initialize(task)
    super(task)
  end

  def tags
    return [PersonalTag.new] if __getobj__.tags.empty?
    __getobj__.tags.map do |tag|
      SharedTag.new(tag)
    end
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
    return nil unless completed?
    completed_task.completed_at.to_date
  end

  def completion_checkbox_state
    return %(checked="checked").html_safe if completed?
    nil
  end

  def show_deadline
    return unless deadline
    I18n.l(deadline, format: :short)
  end
end
