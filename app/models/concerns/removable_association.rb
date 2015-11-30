module RemovableAssociation
  extend ActiveSupport::Concern

  included do
    attr_reader :removed
    alias_method :removed?, :removed

    def remove!
      @removed = true
    end
  end
end
