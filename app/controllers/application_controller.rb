class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |error|
    render_error :not_found, "#{error.model || 'Record'} not found"
  end

  rescue_from ActionController::ParameterMissing do |error|
    render_error :bad_request, error.message
  end

  private

  def render_error(status, message, details = nil)
    body = { error: { status: Rack::Utils.status_code(status), message: } }
    body[:error][:details] = details if details
    render json: body, status:
  end

  def render_validation_errors(record)
    render_error :unprocessable_content, "Validation failed", record.errors.to_hash(true)
  end
end
