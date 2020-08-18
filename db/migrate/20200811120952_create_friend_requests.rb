class CreateFriendRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :friend_requests do |t|
      t.integer :sender_id  #the user that sent the friend req.
      t.integer :receiver_id #the user that receives the friend req.
      
      t.timestamps
    end
  end
end
