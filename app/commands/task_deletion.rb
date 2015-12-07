class TaskDeletion

  def initialize(task)
    @task = task
  end

  def run
    @task.remove!
    @task.save
  end
end
