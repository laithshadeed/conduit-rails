# frozen_string_literal: true

require "base64"

class UsersController < ApplicationController
  KEY = "SECRET"

  def index
    @user = User.find(1)
    render json: { 'profile': format(@user) }, status: 200
  end

  def create
    @user = User.new(params.require(:user).permit(:username, :email, :password))
    @user.save
    render json: { 'created': "OK" }, status: 200
  end

  def update
    @user = User.find(1)
    @user.update(params.require(:user).permit(:username, :email, :password, :image, :bio))
    render json: { user: format(@user) }, status: 200
  end

  def show
    @user = User.find_by(username: params[:username])
    render json: { profile: format_profile(@user) }, status: 200
  end

  def login
    @user = User.find(1)
    render json: { user: format(@user) }, status: 200
  end

  def follow
    render json: { 'followed': params[:username].to_s }, status: 200
  end

  def unfollow
    render json: { 'unfollowed': params[:username].to_s }, status: 200
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
      following: false # TODO
    }
  end

  def decode_token(token)
    (header_encoded, payload_encoded, mac_encoded) = token.split(".")
    payload = Base64.urlsafe_decode64(payload_encoded)
    mac = Base64.urlsafe_decode64(mac_encoded)
    data = header_encoded + "." + payload_encoded
    my_mac = Base64.urlsafe_encode64(OpenSSL::HMAC.digest("sha256", KEY, data))
    payload = nil unless mac == my_mac
    payload
  end

  def encode_token(user)
    header = {
      alg: "HS256",
      typ: "JWT"
    }

    payload = {
      id: user.id,
      username: user.username
    }

    data = Base64.urlsafe_encode64(header.to_json) + "." + Base64.urlsafe_encode64(payload.to_json)
    mac = Base64.urlsafe_encode64(OpenSSL::HMAC.digest("sha256", KEY, data))
    "#{data}.#{mac}"
  end
end
