class CommentsController < ApplicationController
    def create
        post = Post.find_by_id(params[:post_id])
        @new_comment = post.comments.build(comment_params)
        @new_comment.user_id = current_user.id
        if @new_comment.save
            flash[:success] = "Comment posted"
            redirect_to posts_path
        end
    end

    def edit
        user_comment = Comment.includes(:user)
        user_post = Post.includes(:user, :likes, :comments)
        @edit = user_comment.find_by_id(params[:id])
        @post = user_post.find_by_id(params[:post_id])

    end

    def update
        edit_comment = Comment.find_by_id(params[:id])
        if edit_comment.update(comment_params)
            flash[:success] = "Updated comment successfully"
        else
            flash[:fail] = "Failed to update comment"
        end

        redirect_to posts_path
    end

    def destroy
        post = Post.find_by_id(params[:post_id])
        comment = post.comments.find_by_id(params[:id])
        comment.destroy
        flash[:success] = "Comment deleted"
        redirect_to posts_path
    end
    private
    def comment_params
        params.require(:comment).permit(:comment_text)
    end
end
