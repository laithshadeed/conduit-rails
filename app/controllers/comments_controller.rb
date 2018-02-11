class CommentsController < ApplicationController
  def index
    comments = [
      {
        "id": "1",
        "body": "I'm body"
      },
      {
        "id": "2",
        "body": "Hey dude!"
      }
    ]

    render json: {"comments": comments} , status: 200
  end

  def create
    render json: {"created": "#{params[:slug]}"}, status: 200
  end

  def destroy
    render json: {"destroy": "#{params[:slug]}"}, status: 200
  end
end
