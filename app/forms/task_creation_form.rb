class TaskCreationForm < SimpleDelegator

  attr_accessor :with_sign_up

  def initialize(params)
    @with_sign_up = params.delete(:with_sign_up)
    super(TaskParameters.new(params))
  end
end
