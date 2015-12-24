class AssignmentList < SimpleDelegator

  def initialize(assignments = [])
    super(assignments)
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
