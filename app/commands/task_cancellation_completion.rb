class TaskCancellationCompletion

  def initialize(task)
    @task = task
  end

  def run
    @task.cancel_completion
    @task.save
  end
end
