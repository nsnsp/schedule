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

  def bool_icon(bool)
    klass = "glyphicon-#{bool ? 'ok' : 'remove'}"
    "<span class='glyphicon #{klass} bool-icon #{!!bool}'></span>".html_safe
  end

  def versions_table_value(field_name, value, time_zone)
    field_name ||= ''
    value ||= ''

    if field_name.ends_with?('_id')
      begin
        object_name = field_name[0..-4]
        object = object_name.classify.constantize.find(value)

        name = object.respond_to?(:name) ? object.try(:name) : nil
        name = object.to_s if name.blank?
        name = value if name.match(/\A#<.+>\z/)

        return link_to(name, object)
      rescue NameError, NoMethodError, ActiveRecord::RecordNotFound
      end
    end

    value = value.in_time_zone(time_zone) if (value.is_a?(Time) ||
                                              value.is_a?(DateTime))
    value.try(:to_s)
  end

  def even_odd(i)
    (i % 2).zero? ? 'even' : 'odd'
  end
end
