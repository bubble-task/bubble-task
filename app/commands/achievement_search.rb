class AchievementSearch
  include ActiveModel::Model

  attr_accessor :from_date, :to_date
  attr_reader :result

  def run(user_id)
    @result = TaskRepository.all_completed_by_author_id(user_id, from_datetime: from_datetime, to_datetime: to_datetime)
  end

  def has_condition?
    from_date.present? || to_date.present?
  end

  def param_name
    :q
  end

  private

    def from_datetime
      return nil if from_date.blank?
      Time.zone.parse(from_date)
    end

    def to_datetime
      return nil if to_date.blank?
      Time.zone.parse(to_date).end_of_day
    end
end
