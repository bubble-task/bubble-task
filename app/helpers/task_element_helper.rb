module TaskElementHelper
  def task_css_id(task_id)
    "task_#{task_id}"
  end

  def task_completion_css_id(task_id)
    "task_#{task_id}_completion_state"
  end
end
