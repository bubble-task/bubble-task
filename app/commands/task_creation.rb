class TaskCreation < SimpleDelegator

  def initialize(parameters = TaskParameters.new)
    super(parameters)
  end

  def run(user)
    return nil unless valid?
    TaskFactory
      .create(user.id, title, description, tags)
      .tap(&:save)
  end
end
