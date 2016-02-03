class TaskEditingForm < SimpleDelegator
  class << self

    def setup_with_origin(task_id)
      origin = fetch_task(task_id)
      new(
        task_id: origin.id,
        title: origin.title,
        description: origin.description,
        tag_words: build_tag_words(origin.tags),
        deadline_date: origin.deadline&.strftime('%Y/%m/%d'),
        deadline_hour: origin.deadline&.strftime('%H'),
        deadline_minutes: origin.deadline&.strftime('%M'),
      )
    end

    def build_tag_words(tags)
      tags.join(' ')
    end

    private

      def fetch_task(task_id)
        TaskRepository.find_by_id(task_id)
      end
  end

  attr_accessor :task_id, :disable_deadline

  def initialize(params = {})
    @task_id = params.delete(:task_id)
    @disable_deadline = params.delete(:disable_deadline)
    super(TaskParameters.new(params))
  end
end
