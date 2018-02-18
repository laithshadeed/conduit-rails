# frozen_string_literal: true

class FollowersController < ApplicationController
  before_action :authenticate

  def follow
    user = User.find_by(username: params[:username])
    follower = Follower.create(user_id: user.id, follower_id: @current_user.id)
    return server_error unless follower.save
    render json: { "profile": format_profile(user) }, status: 200
  end

  def unfollow
    user = User.find_by(username: params[:username])
    follower = Follower.find_by(user_id: user.id, follower_id: @current_user.id)
    return server_error unless follower.destroy
    render json: { "profile": format_profile(user) }, status: 200
  end
end
