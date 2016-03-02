class TaskPresenter < SimpleDelegator

  def self.create(task)
    if task.completed?
      CompletedTaskPresenter.new(task)
    else
      UncompletedTaskPresenter.new(task)
    end
  end
end
