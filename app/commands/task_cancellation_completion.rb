class TaskCancellationCompletion
  include ActiveModel::Model

  attr_accessor :task_id

  def initialize(*params)
    super
    @task = TaskRepository.find_by_id(task_id)
  end

  def run
    @task.cancel_completion
    @task.save
  end
end
