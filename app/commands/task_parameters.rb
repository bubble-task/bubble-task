class TaskParameters
  include ActiveModel::Model

  attr_accessor :title, :description, :tag_words

  validates :title,
            presence: true,
            length: { maximum: 40 }

  validates :description,
            length: { maximum: 5000 }
end
