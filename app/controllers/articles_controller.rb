class ArticlesController < ApplicationController
    @@articles = [
      {
        "title": "Hello!",
        "body": "I'm body"
      },
      {
        "title": "Another Article",
        "body": "Hey dude!"
      }
    ]

  def index
    render json: {"articles": @@articles, "articlesCount": @@articles.count} , status: 200
  end

  def show
    render json: {"article": @@articles[params[:id].to_i - 1]}, status: 200
  end
end
