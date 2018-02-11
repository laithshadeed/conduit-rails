class UsersController < ApplicationController
  def index
    render json: {"profile": User.find(1)}, status: 200
  end

  def create
    @user = User.new(params.require(:user).permit(:username, :email, :password))
    @user.save
    render json: {"created": "OK"}, status: 200
  end

  def update
    @user = User.find(1)
    @user.update(params.require(:user).permit(:username, :email, :password, :image))
    render json: {"updated": "OK"}, status: 200
  end

  def show
    render json: {"profile": User.find_by(username: params[:username])}, status: 200
  end

  def login
    render json: {"login": "Succeed"}, status: 200
  end

  def follow
    render json: {"followed": "#{params[:username]}"}, status: 200

  end

  def unfollow
    render json: {"unfollowed": "#{params[:username]}"}, status: 200
  end
end
