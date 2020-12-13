Rails.application.config.action_mailer.default_options = {
  from: 'support@nsnsp.org'
}
Rails.application.config.action_mailer.smtp_settings = {
  user_name: 'apikey',
  password: ENV['SENDGRID_API_KEY'],
  domain: 'email.nsnsp.org',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
