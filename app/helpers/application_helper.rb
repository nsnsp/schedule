module ApplicationHelper
  ALERT_TYPES = [:success, :info, :warning, :danger] unless
    const_defined?(:ALERT_TYPES)

  # stolen from http://goo.gl/qP50td
  def bootstrap_flash(options = {})
    flash_messages = []
    flash.each do |type, message|
      next if message.blank?

      glyphicon_map = {
        success: 'ok-sign',
        warning: 'warning-sign',
        danger: 'exclamation-sign',
      }

      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        next unless msg
        content = ''

        if glyphicon_map.key?(type)
          content +=
            content_tag(:span, nil,
                        class: "glyphicon glyphicon-#{glyphicon_map[type]}",
                        'aria-hidden' => true) +
            content_tag(:span, "#{type.to_s.titleize}:",
                        class: 'sr-only')
        end

        content += content_tag(:button, raw('&times;'),
                               class: 'close', 'data-dismiss' => 'alert') + msg

        flash_messages << content_tag(:div, raw(content),
                                      class: ("alert fade in alert-#{type} " \
                                              "#{options[:class]}"))
      end
    end

    flash_messages.join("\n").html_safe
  end

  def bool_icon(bool)
    klass = "glyphicon-#{bool ? 'ok' : 'remove'}"
    "<span class='glyphicon #{klass} bool-icon #{!!bool}'></span>".html_safe
  end

  def versions_table_value(change, which, time_zone)
    field_name = change.try(:[], 0) || '';
    value = change.try(:[], 1).try(which) || '';

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

  def dash(str)
    str.blank? ? '--' : str
  end
end
