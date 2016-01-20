class TodaysTaskList < SimpleDelegator

  def initialize(user_id)
    super([])
    @user_id = user_id
  end

  def add_task(task_id)
    self << TodaysTask.new(task_id: task_id, user_id: @user_id)
  end

  def save
    ActiveRecord::Base.transaction do
      TodaysTask.where(user_id: @user_id).each(&:destroy!)
      each(&:save!)
    end
  end
end
