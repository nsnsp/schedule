Rails.application.config.action_mailer.default_options = {
  from: 'support@nsnsp.org'
}
Rails.application.config.action_mailer.delivery_method = :postmark
Rails.application.config.action_mailer.postmark_settings = {
  api_key: ENV['POSTMARK_API_KEY']
}
