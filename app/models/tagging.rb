class Tagging < ActiveRecord::Base
  belongs_to :task

  attr_reader :removed

  def remove!
    @removed = true
  end

  def removed?
    @removed
  end
end
