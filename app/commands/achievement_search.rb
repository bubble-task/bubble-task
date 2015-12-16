class AchievementSearch
  include ActiveModel::Model

  attr_accessor :from_date, :to_date

  def run(user_id)
    @tasks = TaskRepository.all_completed_by_author_id(user_id, from_date_time: from_date_time, to_date_time: to_date_time).map do |task|
      TaskPresenter.new(task)
    end
  end

  def result
    @tasks
  end

  private

    def from_date_time
      return nil if from_date.blank?
      Time.zone.parse(from_date)
    end

    def to_date_time
      return nil if to_date.blank?
      Time.zone.parse(to_date).end_of_day
    end
end