module UIHelper

  def wait_response_for_async_request
    find('#toast-container')
  end

  alias_method :wait_completion, :wait_response_for_async_request
  alias_method :wait_cancellation_completion, :wait_response_for_async_request
end
