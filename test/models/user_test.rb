require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(first_name: 'Pat', last_name: 'Roller',
                         email: 'pat@example.com')
  end

  test 'a second user with the same name is rejected' do
    twin = User.new(first_name: 'Pat', last_name: 'Roller',
                    email: 'other@example.com')

    assert_not twin.valid?
    assert_includes twin.errors[:base], 'A user named Pat Roller already exists.'
  end

  test 'a user does not collide with its own name' do
    assert @user.update(phone: '530-555-1234')
  end
end
