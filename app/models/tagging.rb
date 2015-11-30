class Tagging < ActiveRecord::Base
  belongs_to :task

  attr_reader :removed
  alias_method :removed?, :removed

  def remove!
    @removed = true
  end
end
