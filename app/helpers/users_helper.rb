module UsersHelper
    def friends_with_user?(friend)
        !User.check_friends(current_user.id, friend.id).empty?
    end
end
