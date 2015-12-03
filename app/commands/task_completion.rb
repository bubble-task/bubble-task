class TaskCompletion
  include ActiveModel::Model

  attr_accessor :task, :tag

  def run
    @task.complete
    @task.save
  end
end
