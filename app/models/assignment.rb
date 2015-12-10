class Assignment < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  def associated?(user)
    user_id == user.id
  end
end
