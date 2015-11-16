class TaskCreation
  include ActiveModel::Model

  attr_accessor :title, :description

  validates :title,
    presence: true,
    length: { maximum: 80 }

  validates :description, length: { maximum: 510 }

  def run(user)
    return nil unless valid?
    user.create_task(title, description).tap do |task|
      task.save
    end
  end
end
