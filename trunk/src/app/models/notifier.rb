class Notifier < ActionMailer::Base
  
  def program_exception(exception, params)
    @subject = exception.message
    @body[:exception] = exception
    @body[:params] = params
    @recipients = User.find(:all, :conditions => [ 'receives_errors = ?', true ]).collect { |u| u.email_address }
    @from = SEND_FROM
  end
end
