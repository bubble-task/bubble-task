class TaskCreation < SimpleDelegator

  def initialize(parameters = TaskParameters.new)
    super(parameters)
  end

  def run(user)
    return nil unless valid?
    user
      .create_task(title, description, tags)
      .tap(&:save)
  end
end
