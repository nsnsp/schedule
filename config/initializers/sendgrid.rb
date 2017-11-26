Rails.application.config.action_mailer.default_options = {
  from: 'support@nsnsp.org'
}
Rails.application.config.action_mailer.smtp_settings = {
  user_name: ENV['SENDGRID_USERNAME'],
  password: ENV['SENDGRID_PASSWORD'],
  domain: 'nsnsp.org',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
