module Criteria
  module Conditions
    module Creatable

      def create(value)
        return Conditions::Nil unless value
        new(value)
      end
    end
  end
end
