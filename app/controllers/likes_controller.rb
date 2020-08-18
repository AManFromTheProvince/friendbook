class LikesController < ApplicationController
    before_action :signed_in?
    def create
        post = Post.find_by_id(params[:post_id])
        @new_like = post.likes.build({user_id: current_user.id})
        if @new_like.save
            redirect_to posts_path
        end
    end

    def destroy
        post = Post.find_by_id(params[:post_id])
        @like = post.likes.where("user_id = ?", current_user.id).first
        Like.destroy(@like.id)
        redirect_to posts_path      
    end
end
