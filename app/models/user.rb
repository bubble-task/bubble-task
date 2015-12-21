class User < ActiveRecord::Base
  has_one :oauth_credential

  delegate :provider, :uid, to: :oauth_credential

  def take_task(task, assignment_list)
    assignment_list.add(Assignment.new(task: task, user: self))
  end

  def abandon_task(task, assignment_list)
    assignment_list.remove(Assignment.new(task: task, user: self))
  end
end
