module ErrorHandling
  def respond_with_error(error, invalid_resource = nil)
    error = API_ERRORS[error]
    if invalid_resource
      error['errors'] = invalid_resource.errors.full_messages
    else
      error['errors'] = [error['title']]
    end
    render json: error, status: error['status']
  end
end
