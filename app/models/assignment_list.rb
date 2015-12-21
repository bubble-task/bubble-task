class AssignmentList < SimpleDelegator

  def initialize(assignments = [])
    super(assignments)
  end

  def add(assignment)
    return self if include?(assignment)
    self.class.new(self + [assignment])
  end

  def remove(assignment)
    new_list = self.dup.tap { |me| me.delete(assignment) }
    self.class.new(new_list)
  end

  def save
    reject(&:persisted?).each(&:save)
  end
end
