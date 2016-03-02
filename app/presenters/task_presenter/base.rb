module TaskPresenter
  class Base < SimpleDelegator

    def tags
      TagPresenter.create(__getobj__.tags)
    end
  end
end
