class User < ActiveRecord::Base
  has_one :oauth_credential

  delegate :provider, :uid, to: :oauth_credential

  def create_task(title, description = nil, tags = [])
    TaskFactory.create(id, title, description, tags)
  end

  def take_task(task, assignment_list)
    return assignment_list if assignment_list.include?(new_assignment(task))
    assignment_list.add(new_assignment(task))
  end

  private

    def new_assignment(task)
      @new_assignment ||= Assignment.new(user: self, task: task)
    end
end
