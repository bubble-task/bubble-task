module Criteria
  class Achievement
    CompletedOnTo = Struct.new(:datetime) do
      extend Creatable

      def satisfy(relation)
        relation.where('completed_tasks.completed_at <= ?', datetime)
      end
    end
  end
end
