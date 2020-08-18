class FriendshipsController < ApplicationController
    before_action :signed_in?
    def index
        @user_friendship = User.includes(:friendship)    
        @received_requests = @user_friendship.received_request(current_user.id)
        @sent_requests =  @user_friendship.sent_request(current_user.id)
    end
    
    def create
        new_fr = current_user.sent_friendship.build({receiver_id: params[:user_id], status: "Request"})
        if new_fr.save
            flash[:success] = "Friend request sent"
            redirect_to posts_path
        else
            flash[:fail] = "Friend request failed to process. Try again later."
        end
    end

    def destroy #removes the friend request that you SENT
        fr = current_user.sent_friendship.where("receiver_id = ?", params[:id]).first
        fr.destroy
        flash[:success] = "Friend request cancelled"
        redirect_to user_friendships_path
    end

    def accept
        accept_fr = current_user.received_friendship.where("sender_id = ?", params[:id])
        if accept_fr.update({status: "Friends"})
            flash[:success] = "Friendship accepted"
        else
            flash[:notice] = "Cannot add him/her now. Try again later"
        end
        redirect_to user_friendships_path
    end

    def remove #removes the fr that you RECEIVED
        accept_fr = current_user.received_friendship.where("sender_id = ?", params[:id]).first
        accept_fr.destroy
        flash[:success]  = "Friend request deleted"
        redirect_to user_friendships_path
    end
end
