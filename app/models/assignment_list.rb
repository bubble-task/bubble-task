class AssignmentList < SimpleDelegator

  def initialize(assignments = [])
    super(assignments)
  end

  def add(assignment)
    self.class.new(self + [assignment])
  end

  def save
    reject(&:persisted?).each(&:save)
  end
end
