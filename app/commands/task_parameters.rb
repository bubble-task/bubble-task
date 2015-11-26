class TaskParameters
  include ActiveModel::Model

  attr_accessor :title, :description, :tag_words

  validates :title,
            presence: true
end
