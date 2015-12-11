class User < ActiveRecord::Base
  has_one :oauth_credential

  delegate :provider, :uid, to: :oauth_credential

  def create_task(title, description = nil, tags = [])
    TaskFactory.create(id, title, description, tags)
  end

  def take_task(task, assignment_list)
    assignment_list.add(Assignment.new(task: task, user: self))
  end
end
