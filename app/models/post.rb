class Post < ApplicationRecord
    belongs_to :user
    has_many :likes, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_one_attached :post_picture

    scope :all_friend_and_own_posts, ->(user_id) {find_by_sql ["SELECT posts.* FROM posts WHERE posts.user_id IN (SELECT users.id FROM users WHERE users.id IN (SELECT friendships.receiver_id FROM friendships INNER JOIN users ON users.id = sender_id WHERE users.id = :user_id AND status = 'Friends' UNION SELECT friendships.sender_id FROM friendships INNER JOIN users ON users.id = receiver_id WHERE users.id = :user_id AND status = 'Friends') AND users.id != :user_id) OR posts.user_id = :user_id ORDER BY posts.created_at DESC", {:user_id => user_id}]}
        
end
