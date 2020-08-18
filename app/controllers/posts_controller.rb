class PostsController < ApplicationController
    include PostsHelper
    before_action :signed_in?
    
    def index
        @new_post = Post.new
        @new_comment = Comment.new
        
        @post_with_users = Post.includes(:user, :comments, :likes)
        @user_friendship = User.includes(:friendship)

        @user_posts = @post_with_users.all_friend_and_own_posts(current_user.id)
        
        @not_friends = @user_friendship.not_friends_or_request(current_user.id)
        @friends = @user_friendship.friends_list(current_user.id).length     
    end

    def edit
        post_with_user = Post.includes(:user)
        @edit = post_with_user.find_by_id(params[:id])
    end

    def update
        @edit = Post.find_by_id(params[:id])
        if @edit.update(post_params)
            flash[:success] = "Successfully updated your post" 
        else
            flash[:fail] = "Cannot update your post right now"
        end
        redirect_to posts_path
    end

    def create
        @created_post = current_user.posts.build(post_params)
        if @created_post.save
            flash[:success] = "Successfully posted!"
        else
            flash[:fail] = "Error when posting! Try again later."
        end
        redirect_to posts_path
    end

    def destroy
        post = Post.find_by_id(params[:id])
        post.destroy
        flash[:success] = "Post deleted"
        redirect_to posts_path
    end

    private
    def post_params
        params.require(:post).permit(:body_text, :post_picture)
    end
end
