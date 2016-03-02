module TaskElementHelper
  def task_css_id(task_id)
    "task_#{task_id}"
  end

  def task_completion_css_id(task_id)
    "task_#{task_id}_completion_state"
  end

  def hide_task_on_success?
    return false if from_show_task?
    return false if from_search_any_task_result?
    true
  end
end
