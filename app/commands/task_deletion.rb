class TaskDeletion

  def initialize(task_id:)
    @task = TaskRepository.find_by_id(task_id)
  end

  def run
    @task.remove!
    @task.save
  end
end
