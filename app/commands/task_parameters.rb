class TaskParameters
  include ActiveModel::Model

  attr_accessor :title, :description, :tag_words, :deadline_date, :deadline_hour, :deadline_minutes

  validates :title,
            presence: true,
            length: { maximum: 40 }

  validates :description,
            length: { maximum: 5000 }

  validates :tag_words, tag_words: true

  validates :deadline_date,
            presence: true,
            if: 'deadline_hour.present? || deadline_minutes.present?'

  validates :deadline_hour,
            presence: true,
            if: 'deadline_date.present? && deadline_minutes.present?'

  def self.tags_from(tag_words)
    return [] unless tag_words
    tag_words.split(/\s+/)
  end

  def tags
    self.class.tags_from(tag_words)
  end

  def deadline
    Time.zone.parse("#{deadline_date} #{deadline_hour}:#{deadline_minutes}")
  end
end
