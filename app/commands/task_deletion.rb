class TaskDeletion

  def initialize(task_id: task_id)
    @task_id = task_id
  end

  def run
    task.remove!
    task.save
  end

  private

    def task
      @task ||= TaskRepository.find_by_id(@task_id)
    end
end
