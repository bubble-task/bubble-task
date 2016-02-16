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

  def signed_up?(user)
    assignees.include?(user)
  end

  def completed_on
    return nil unless completed?
    completed_task.completed_at.to_date
  end

  def completion_checkbox_state
    return %(checked="checked" disabled="disabled").html_safe if completed?
    nil
  end

  def cancel_completion_link(view)
    return '' unless completed?
    view.link_to view.cancel_completion_task_url(self), method: :put, class: 'cancel-completion tooltipped', data: { tooltip: I18n.t('helpers.actions.cancel_completion') } do
      view.content_tag(:i, 'done', class: 'material-icons')
    end
  end

  def show_deadline
    return unless deadline
    I18n.l(deadline, format: :short)
  end
end
