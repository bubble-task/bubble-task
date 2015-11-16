class TaskCreation
  include ActiveModel::Model

  attr_accessor :title, :description

  validates :title,
    presence: true,
    length: { maximum: 40 }

  validates :description,
    length: { maximum: 255 }

  def run(user)
    return nil unless valid?
    user
      .create_task(title, description)
      .tap(&:save)
  end
end
