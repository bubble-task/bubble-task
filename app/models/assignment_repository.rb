module AssignmentRepository
  module_function

  def for_user(user_id)
    AssignmentList.new(Assignment.where(user_id: user_id))
  end
end
