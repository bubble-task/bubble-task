class AchievementCriteriaForm
  include ActiveModel::Model

  attr_accessor :author_id, :from_date, :to_date

  delegate :param_name, to: self

  def self.param_name
    :c
  end

  def criteria
    Criteria::Achievement.new do |c|
      c.add_condition(Criteria::Conditions::Author.create(author_id))
      c.add_condition(Criteria::Conditions::CompletedOnFrom.create(from_datetime))
      c.add_condition(Criteria::Conditions::CompletedOnTo.create(to_datetime))
    end
  end

  def has_condition?
    from_date.present? || to_date.present?
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
