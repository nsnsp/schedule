# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.connect_src :self,
                       "https://*.google-analytics.com",
                       "https://*.analytics.google.com",
                       "https://*.googletagmanager.com",
                       "https://*.nr-data.net",
                       "https://api.rollbar.com"
    policy.font_src    :self
    policy.img_src     :self, :data,
                       "https://static.nsnsp.org",
                       "https://*.google-analytics.com",
                       "https://*.analytics.google.com",
                       "https://*.googletagmanager.com"
    policy.object_src  :none
    policy.script_src  :self,
                       "https://www.googletagmanager.com",
                       "https://*.google-analytics.com",
                       "https://js-agent.newrelic.com",
                       "https://cdn.rollbar.com"
    policy.style_src   :self, :https
    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  config.content_security_policy_nonce_generator = ->(request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w(script-src style-src)

  # Automatically add `nonce` to `javascript_tag`, `javascript_include_tag`, and `stylesheet_link_tag`
  # if the corresponding directives are specified in `content_security_policy_nonce_directives`.
  config.content_security_policy_nonce_auto = true

#   # Report violations without enforcing the policy.
#   # config.content_security_policy_report_only = true
end
