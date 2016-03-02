module TaskPresenter

  def self.create(task)
    base = Base.new(task)
    if task.completed?
      Completed.new(base)
    else
      Uncompleted.new(base)
    end
  end
end
