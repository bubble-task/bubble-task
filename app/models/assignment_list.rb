class AssignmentList < SimpleDelegator

  def initialize(task_id, assignments = [])
    super(assignments)
    @task_id = task_id
  end

  def add_assignee(user_id)
    add(Assignment.new(task_id: @task_id, user_id: user_id))
  end

  def add(assignment)
    return self if include?(assignment)
    self.tap { |me| me << assignment }
  end

  def remove(assignment)
    self.tap do |me|
      me.detect { |a| a == assignment }.remove!
    end
  end

  def empty?
    reject(&:removed?).empty?
  end

  def save
    each(&:save)
  end
end
