class Tagging < ActiveRecord::Base
  include RemovableAssociation

  belongs_to :task
end
