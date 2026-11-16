require 'test_helper'

class CommitmentTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(first_name: 'Pat', last_name: 'Roller',
                         email: 'pat@example.com')

    # a day comfortably inside the current season
    @day = Season.new.date_range.first + 60
    freeze_time = @day.to_time + Commitment::LOCAL_FREEZE_HOUR.hours
    @before_freeze = freeze_time - 1.minute
    @after_freeze = freeze_time + 1.minute
  end

  test 'signing up is allowed before the day is frozen' do
    travel_to @before_freeze do
      assert Commitments::Patrol.new(user: @user, date: @day).save
    end
  end

  test 'signing up is refused once the day is frozen' do
    travel_to @after_freeze do
      commitment = Commitments::Patrol.new(user: @user, date: @day)

      assert_not commitment.save
      assert_match(/too late to sign up/, commitment.errors[:base].to_sentence)
    end
  end

  test 'cancelling is allowed before the day is frozen' do
    travel_to @before_freeze do
      commitment = Commitments::Patrol.create!(user: @user, date: @day)

      assert commitment.destroy
      assert_not Commitment.exists?(commitment.id)
    end
  end

  test 'cancelling is refused once the day is frozen' do
    commitment = travel_to(@before_freeze) do
      Commitments::Patrol.create!(user: @user, date: @day)
    end

    travel_to @after_freeze do
      assert_not commitment.destroy
      assert Commitment.exists?(commitment.id)
      assert_match(/too late to cancel/, commitment.errors[:base].to_sentence)
    end
  end
end
