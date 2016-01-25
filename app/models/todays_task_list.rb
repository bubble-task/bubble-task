class TodaysTaskList < SimpleDelegator

  def initialize(user_id, tasks = [])
    super(tasks.dup)
    @user_id = user_id
  end

  def add_task(task_id)
    return if detect_by_task_id(task_id)
    self << TodaysTask.new(task_id: task_id, user_id: @user_id)
  end

  def remove_task(task_id)
    detect_by_task_id(task_id).remove!
  end

  def empty?
    reject(&:removed?).empty?
  end

  def save
    ActiveRecord::Base.transaction do
      each do |t|
        t.destroy! if t.removed?
        t.save!
      end
    end
  end

  private

    def detect_by_task_id(task_id)
      detect { |t| t.task_id == task_id }
    end
end
