module Removable
  attr_reader :removed
  alias_method :removed?, :removed

  def remove!
    @removed = true
  end

  def apply_removed!
    destroy! if @removed
  end
end
