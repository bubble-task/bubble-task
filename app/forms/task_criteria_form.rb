class TaskCriteriaForm
  include ActiveModel::Model

  attr_accessor :from_date, :to_date, :tag_words, :is_signed_up_only, :completion_state

  delegate :param_name, to: self

  TRUE_VALUE = '1'.freeze

  def self.param_name
    :c
  end

  def initialize(searcher_id, params)
    @searcher_id = searcher_id
    fill_is_signed_up_only(params)
    super(params)
  end

  def criteria
    Criteria::Task.create(
      @searcher_id,
      assignee_id: signed_up_only? && @searcher_id,
      from_date: from_datetime,
      to_date: to_datetime,
      tag_words: tag_words,
      completion_state: completion_state,
    )
  end

  def has_additional_condition?
    from_date.present? || to_date.present? || tag_words.present? || !signed_up_only?
  end

  def from_datetime
    return nil if from_date.blank?
    Time.zone.parse(from_date)
  end

  def to_datetime
    return nil if to_date.blank?
    Time.zone.parse(to_date).end_of_day
  end

  private

    def fill_is_signed_up_only(params)
      params[:is_signed_up_only] = TRUE_VALUE if params[:is_signed_up_only].nil?
    end

    def signed_up_only?
      is_signed_up_only == TRUE_VALUE
    end
end
