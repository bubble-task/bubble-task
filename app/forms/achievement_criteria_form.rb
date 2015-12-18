class AchievementCriteriaForm
  include ActiveModel::Model

  attr_accessor :author_id, :from_date, :to_date

  def self.param_name
    :c
  end

  def criteria
    criteria = Criteria::Achievement.new
    criteria.add_condition(Criteria::Achievement::Author.new(author_id))
    criteria.add_condition(Criteria::Achievement::CompletedOnFrom.create(from_datetime))
    criteria.add_condition(Criteria::Achievement::CompletedOnTo.create(to_datetime))
    criteria
  end

  def has_condition?
    from_date.present? || to_date.present?
  end

  def param_name
    self.class.param_name
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
