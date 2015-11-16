class TaskForm
  include ActiveModel::Model

  attr_accessor :title, :description

  validates :title,
    presence: true,
    length: { maximum: 80 }
end
