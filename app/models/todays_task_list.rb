class TodaysTaskList < SimpleDelegator

  def initialize(user_id, tasks = [])
    super(tasks.dup)
    @user_id = user_id
  end

  def add_task(task_id)
    self << TodaysTask.new(task_id: task_id, user_id: @user_id)
  end

  def save
    ActiveRecord::Base.transaction do
      select { |t| t.id.nil? }.each(&:save!)
    end
  end
end
