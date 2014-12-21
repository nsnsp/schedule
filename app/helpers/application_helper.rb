module ApplicationHelper
  ALERT_TYPES = [:success, :info, :warning, :danger] unless
    const_defined?(:ALERT_TYPES)

  # stolen from http://goo.gl/qP50td
  def bootstrap_flash(options = {})
    flash_messages = []
    flash.each do |type, message|
      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"),
                                       class: "close",
                                       "data-dismiss" => "alert") + msg,
                           class: "alert fade in alert-#{type} #{options[:class]}")
        flash_messages << text if msg
      end
    end

    flash_messages.join("\n").html_safe
  end
end
