class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,  omniauth_providers: [:facebook]

  
  has_many :sent_friendship, foreign_key: "sender_id", class_name: "Friendship"
  has_many :received_friendship, foreign_key: "receiver_id", class_name: "Friendship"
  has_many :posts, dependent: :destroy
  has_many :likes
  has_many :comments
  has_one_attached :profile_picture

  def self.from_omniauth(auth)
    puts auth.info
    puts "=========================="
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0, 20]
    end
  end

  scope :friends_list, ->(user_id) { find_by_sql ["SELECT users.* FROM users WHERE users.id IN (SELECT friendships.receiver_id FROM friendships INNER JOIN users ON users.id = sender_id WHERE users.id = ? AND status = ? UNION SELECT friendships.sender_id FROM friendships INNER JOIN users ON users.id = receiver_id WHERE users.id = ? AND status = ?) AND users.id != ?", user_id,"Friends",  user_id, "Friends", user_id]}
  scope :sent_request, ->(user_id) { find_by_sql ["SELECT users.* FROM users WHERE users.id IN (SELECT friendships.receiver_id FROM users INNER JOIN friendships ON sender_id = users.id WHERE users.id = ? AND status = 'Request')", user_id]}
  scope :received_request, ->(user_id) { find_by_sql ["SELECT users.* FROM  users where users.id IN (SELECT friendships.sender_id FROM users INNER JOIN friendships ON receiver_id = users.id WHERE users.id = ? AND status = 'Request')", user_id]}
  scope :not_friends_or_request, ->(user_id) { find_by_sql ["SELECT users.* FROM users WHERE users.id NOT IN (SELECT friendships.receiver_id FROM friendships INNER JOIN users ON users.id = sender_id WHERE users.id = :user AND status IN ('Friends', 'Request') UNION SELECT friendships.sender_id FROM friendships INNER JOIN users ON users.id = receiver_id WHERE users.id = :user AND status IN ('Friends','Request')) AND users.id != :user", {user: user_id}]}
  scope :check_friends, ->(user_id, friend_id) { find_by_sql ["SELECT users.* FROM users WHERE users.id IN (SELECT friendships.receiver_id FROM friendships INNER JOIN users ON users.id = sender_id WHERE users.id = ? AND status = ? UNION SELECT friendships.sender_id FROM friendships INNER JOIN users ON users.id = receiver_id WHERE users.id = ? AND status = ?) AND users.id = ?", user_id,"Friends",  user_id, "Friends", friend_id]}
end

