require 'active_support/concern'

module Nameable
  extend ActiveSupport::Concern

  def name
    value = [first_name, last_name].compact.join(' ')
    value.blank? ? nil : value
  end
end
