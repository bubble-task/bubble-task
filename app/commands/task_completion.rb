class TaskCompletion
  include ActiveModel::Model

  attr_accessor :task_id

  def run
    task.complete
    task.save
  end

  def result
    task
  end

  private

    def task
      @task ||= TaskRepository.find_by_id(task_id)
    end
end
