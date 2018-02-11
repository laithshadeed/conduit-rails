class TagsController < ApplicationController
  def index
    tags = [
      "reactjs",
      "elm"
    ]

    render json: {"tags": tags} , status: 200
  end
end
