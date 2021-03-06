class TaskParameters
  include ActiveModel::Model

  attr_accessor :title, :description, :tag_words, :deadline_date, :deadline_hour, :deadline_minutes

  validates :title,
            presence: true,
            length: { maximum: 80 }

  validates :description,
            length: { maximum: 5000 }

  validates :tag_words, tag_words: true

  validates :deadline_date,
            presence: true,
            if: :will_set_deadline?

  validates :deadline_hour,
            presence: true,
            if: :will_set_deadline_time?

  def self.tags_from(tag_words)
    return [] unless tag_words
    tag_words.split(/\s+/)
  end

  def tags
    self.class.tags_from(tag_words)
  end

  def deadline
    return nil if deadline_date.blank?
    Time.zone.parse("#{deadline_date} #{deadline_hour.to_i}:#{deadline_minutes.to_i}")
  end

  private

    def will_set_deadline?
      deadline_hour.present? || deadline_minutes.present?
    end

    def will_set_deadline_time?
      deadline_date.present? && deadline_minutes.present?
    end
end
