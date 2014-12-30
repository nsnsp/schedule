module UsersHelper
  def roles(user)
    user.role_symbols.sort.map { |role| role.to_s.humanize }.join(', ')
  end
end
