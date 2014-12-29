class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new # guest user (not logged in)

    # God (but allow to be overridden by subsequent 'cannot' invocations)
    can :manage, :all if user.is?(:admin)

    # Commitment
    can :index, Commitment
    can :create, Commitment, user_id: user.id if user.is?(:national)
    can :destroy, Commitment, user_id: user.id

    # User
    can :read, User
    can :update, User, id: user.id
    can :manage, User if user.is?(:user_manager)
    cannot [:destroy, :suspend, :unsuspend], User, id: user.id

    # Disallow everything to guests and suspended users (redundant, but safe)
    cannot :manage, :all if user.id.nil? || user.suspended?
  end
end
