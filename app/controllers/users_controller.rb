class UsersController < ApplicationController
  @@users = {
    "laith": {
      "username": "laith",
      "bio": "im Laith"
    },
    "ayham": {
      "username": "ayham",
      "bio": "im Ayham"
    },
    "rick": {
      "username": "rick",
      "bio": "im Rick"
    }
  }

  def index
    render json: {"profile": @@users[:laith]}, status: 200
  end

  def create
    render json: {"created": "OK"}, status: 200
  end

  def show
    render json: {"profile": @@users[params[:username].to_sym]}, status: 200
  end

  def update
    render json: {"updated": "OK"}, status: 200
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
