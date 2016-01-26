class TaskScheduling

  def initialize(task_id, todays_tasks)
    @task_id = task_id
    @todays_tasks = todays_tasks
  end

  def run
    @todays_tasks.add_task(@task_id)
    @todays_tasks.save
  end
end
