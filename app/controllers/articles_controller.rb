class ArticlesController < ApplicationController
    @@articles = {
      "hello":
        {
          "title": "Hello!",
          "slug": "hello",
          "body": "I'm body"
        },
      "how-to-train-your-dragon":
        {
          "title": "Another Article",
          "slug": "how-to-train-your-dragon",
          "body": "Hey dude!"
        }
    }

  def index
    render json: {"articles": @@articles, "articlesCount": @@articles.count} , status: 200
  end

  def create
    render json: {"created": "ok"}, status: 200
  end

  def show
    render json: {"article": @@articles[params[:slug].to_sym]}, status: 200
  end

  def update
    render json: {"updated": "#{params[:slug]}"}, status: 200
  end

  def destroy
    render json: {"deleted": "#{params[:slug]}"}, status: 200
  end

  def favorite
    render json: {"favorite": "#{params[:slug]}"}, status: 200
  end

  def unfavorite
    render json: {"unfavorite": "#{params[:slug]}"}, status: 200
  end

  def feed
    render json: {"feeds": 2}, status: 200
  end
end
