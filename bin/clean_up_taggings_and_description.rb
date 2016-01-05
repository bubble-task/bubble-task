task_ids = Task.pluck(:id)
tasks_with_description = TaskDescription.pluck(:task_id)
tasks_with_tag = Tagging.pluck(:task_id).uniq
task_ids_for_deleting = (tasks_with_tag + tasks_with_description).uniq - task_ids
TaskDescription.where(task_id: task_ids_for_deleting).destroy_all
Tagging.where(task_id: task_ids_for_deleting).destroy_all
