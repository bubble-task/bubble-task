class TaskForm
  include ActiveModel::Model

  attr_accessor(
    :title,
    :description,
  )
end
