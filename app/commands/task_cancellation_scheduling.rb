class TaskCancellationScheduling

  def initialize(task_id, todays_tasks)
    @task_id = task_id.to_i
    @todays_tasks = todays_tasks
  end

  def run
    @todays_tasks.remove_task(@task_id)
    @todays_tasks.save
  end
end
