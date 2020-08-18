module PostsHelper
    def did_user_like_post?(post)
        if post.likes.empty?
            return false
        end
        !post.likes.where("user_id = ?", current_user.id).empty?
    end

    def sent_friend_request?(friend)
        if current_user.sent_friendship.empty?
            return false
        end
        !current_user.sent_friendship.where("receiver_id = ?", friend.id).empty?
    end

    def received_friend_request?(friend)
        if current_user.received_friendship.empty?
            return false
        end
        !current_user.received_friendship.where("sender_id = ?", friend.id).empty?
    end
end
