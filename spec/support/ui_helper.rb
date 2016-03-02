module UIHelper

  def completion_checkbox_id(task_id)
    "#task_#{task_id}_completion_check"
  end

  def completion_checkbox(task_id, maybe: true)
    id = completion_checkbox_id(task_id)
    if maybe
      first(id, visible: false)
    else
      find(id, visible: false)
    end
  end

  def complete_task(task_id)
    id = "#task_#{task_id}_completion_mark"
    find(id, visible: false).click
  end
  alias_method :uncomplete_task, :complete_task

  def wait_response_for_async_request
    find('#toast-container')
  end
  alias_method :wait_completion, :wait_response_for_async_request
  alias_method :wait_cancellation_completion, :wait_response_for_async_request
end
