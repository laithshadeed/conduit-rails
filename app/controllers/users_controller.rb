# frozen_string_literal: true

# TODO: Add error handling
# TODO: Implement follow/unfollow

require "base64"

class UsersController < ApplicationController
  before_action :authenticate, except: %i[login create show]

  def index
    render json: { user: format(@current_user) }, status: 200
  end

  def create
    user = User.new(params.require(:user).permit(:username, :email, :password))
    return server_error unless user.save
    render json: { user: format(user) }, status: 200
  end

  def update
    can_update = @current_user.update(params.require(:user).permit(:username, :email, :password, :image, :bio))
    return server_error unless can_update
    render json: { user: format(@current_user) }, status: 200
  end

  def show
    user = User.find_by(username: params[:username])
    return not_found if user.nil?
    render json: { profile: format_profile(user) }, status: 200
  end

  def login
    user = User.find_by(params.require(:user).permit(:email, :password))
    return not_found if user.nil?
    render json: { user: format(user) }, status: 200
  end

  def follow
    render json: { profile: format_profile(@current_user) }, status: 200
  end

  def unfollow
    render json: { profile: format_profile(@current_user) }, status: 200
  end

  private

  def format(user)
    {
      id: user.id,
      email: user.email,
      token: encode_token(user),
      username: user.username,
      bio: user.bio,
      image: user.image,
      createdAt: user.created_at,
      updatedAt: user.updated_at
    }
  end

  def format_profile(user)
    {
      username: user.username,
      bio: user.bio,
      image: user.image,
      following: false
    }
  end
end
