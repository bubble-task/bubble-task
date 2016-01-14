class TaskCreationForm < SimpleDelegator

  attr_accessor :with_sign_up

  def initialize(params)
    @with_sign_up = params.delete(:with_sign_up)
    super(TaskParameters.new(params))
  end

  def with_sign_up?
    @with_sign_up == '1'
  end
end
