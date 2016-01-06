module Criteria
  module Conditions
    CompletedOnFrom = Struct.new(:datetime) do
      extend Creatable

      def prepare(relation)
        relation
      end

      def satisfy(relation)
        relation.restrict_by_complated_after(datetime)
      end
    end
  end
end
