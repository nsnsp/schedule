class ApplicationMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper

  default from: 'support@nsnsp.org'
  layout 'mailer'
end
