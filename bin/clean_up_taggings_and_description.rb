task_ids = Task.pluck(:id)
puts "Tasks: #{task_ids}"

tasks_with_description = TaskDescription.pluck(:task_id)
puts "TaskDescriptions: #{tasks_with_description}"

tasks_with_tag = Tagging.pluck(:task_id)
puts "Taggings: #{tasks_with_tag}"

tasks_with_completion = CompletedTask.pluck(:task_id)
puts "CompletedTasks: #{tasks_with_completion}"

task_ids_for_deleting = (tasks_with_tag + tasks_with_description + tasks_with_completion).uniq - task_ids
puts "Target Task ids: #{task_ids_for_deleting}"

TaskDescription.where(task_id: task_ids_for_deleting).destroy_all
Tagging.where(task_id: task_ids_for_deleting).destroy_all
CompletedTask.where(task_id: task_ids_for_deleting).destroy_all
