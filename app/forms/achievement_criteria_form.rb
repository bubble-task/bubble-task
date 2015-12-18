class AchievementCriteriaForm
  include ActiveModel::Model

  attr_accessor :author_id, :from_date, :to_date

  def criteria
    self
  end

  def has_condition?
    from_date.present? || to_date.present?
  end

  def param_name
    :q
  end

  def from_datetime
    return nil if from_date.blank?
    Time.zone.parse(from_date)
  end

  def to_datetime
    return nil if to_date.blank?
    Time.zone.parse(to_date).end_of_day
  end
end
