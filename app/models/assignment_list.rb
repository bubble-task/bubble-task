class AssignmentList < SimpleDelegator

  def initialize(task_id, assignments = [])
    super(assignments)
    @task_id = task_id
  end

  def add_assignee(user_id)
    add_assignment(Assignment.new(task_id: @task_id, user_id: user_id))
  end

  def remove_assignee(user_id)
    remove_assignment(Assignment.new(task_id: @task_id, user_id: user_id))
  end

  def empty?
    reject(&:removed?).empty?
  end

  def save
    ActiveRecord::Base.transaction do
      each do |assignment|
        assignment.destroy! if assignment.removed?
        assignment.save!
      end
    end
  end

  private

    def add_assignment(assignment)
      return self if include?(assignment)
      self << assignment
    end

    def remove_assignment(assignment)
      self.detect { |a| a == assignment }.remove!
    end
end
