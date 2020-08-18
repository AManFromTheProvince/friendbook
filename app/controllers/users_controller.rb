class UsersController < ApplicationController
    def show
        if params[:id] != current_user.id
            show_user = params[:id]
        end
        @new_post = Post.new
        @new_comment = Comment.new
        

        @user = User.find_by_id(show_user || current_user.id)
        @user_friendship = User.includes(:friendship)
        @friends = @user_friendship.friends_list(show_user || current_user.id) 

        @post_with_users = Post.includes(:user, :comments, :likes)
        @user_posts = @post_with_users.where("user_id = ?", show_user || current_user.id).order("created_at DESC")
    end
end
