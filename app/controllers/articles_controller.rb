# frozen_string_literal: true

class ArticlesController < ApplicationController
  def index
    @articles = []
    Article.all.includes(:user).each do |a|
      @articles.push(format(a))
    end

    render json: { "articles": @articles, "articlesCount": @articles.count }, status: 200
  end

  def create
    @options = params.require(:article).permit(:title, :description, :body)
    @options[:user] = User.find(1)
    @options[:slug] = @options[:title].downcase.tr(" ", "-")
    @article = Article.new(@options)
    @article.save
    render json: { "article": format(@article) }, status: 200
  end

  def show
    article = format(Article.find_by(slug: params[:slug]))
    render json: { "article": article }, status: 200
  end

  def update
    @article = Article.find_by(slug: params[:slug])
    @article.update(params.require(:article).permit(:title, :description, :body))
    render json: { "article": format(@article) }, status: 200
  end

  def destroy
    @article = Article.find_by(slug: params[:slug])
    @article.destroy
    render json: {}, status: 200
  end

  def favorite
    render json: { "favorite": params[:slug].to_s }, status: 200
  end

  def unfavorite
    render json: { "unfavorite": params[:slug].to_s }, status: 200
  end

  def feed
    render json: { articles: [], articlesCount: 0 }, status: 200
  end

  private

  def format(a)
    article = {}
    article[:title] = a.title
    article[:slug] = a.slug
    article[:body] = a.body
    article[:createdAt] = a.created_at
    article[:updatedAt] = a.updated_at
    article[:tagList] = [] # TODO
    article[:description] = a.description
    article[:author] = {
      username: a.user.username,
      bio: a.user.bio,
      image: a.user.image,
      following: false # TODO
    }
    article[:favorited] = false # TODO
    article[:favoritesCount] = 0 # TODO
    article
  end
end
