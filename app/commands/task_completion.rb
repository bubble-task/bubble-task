class TaskCompletion
  include ActiveModel::Model

  attr_accessor :task

  def run
    @task.complete
    @task.save
  end
end
