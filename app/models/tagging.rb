class Tagging < ActiveRecord::Base
  include Removable

  belongs_to :task
end
