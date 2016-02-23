class TaskCompletion
  include ActiveModel::Model

  attr_accessor :task_id

  def initialize(*params)
    super
    @task = TaskRepository.find_by_id(task_id)
  end

  def run(user_id)
    @task.complete(user_id)
    @task.save
  end

  def result
    @task
  end
end
