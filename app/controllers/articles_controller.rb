# frozen_string_literal: true

# TODO: Add error handling
# TODO: Implement filters
# TODO: Implement pagination
# TODO: Implement limits
# TODO: Implement feed (created articles by followers)
# TODO: Implement tagList
# TODO: Implement update slug when title updates

class ArticlesController < ApplicationController
  before_action :authenticate, except: %i[index show]

  def index
    articles = []
    Article.all.includes(:user, :favorites).each do |a|
      articles.push(format_article(a))
    end

    render json: { "articles": articles, "articlesCount": articles.count }, status: 200
  end

  def create
    options = params.require(:article).permit(:title, :description, :body)
    options[:user] = @current_user
    options[:slug] = options[:title].downcase.tr(" ", "-")
    article = Article.new(options)
    article.save
    render json: { "article": format_article(article) }, status: 200
  end

  def show
    article = format_article(Article.find_by(slug: params[:slug]))
    render json: { "article": article }, status: 200
  end

  def update
    article = Article.find_by(slug: params[:slug])
    return forbidden unless article.user_id == @current_user.id
    article.update(params.require(:article).permit(:title, :description, :body))
    render json: { "article": format_article(article) }, status: 200
  end

  def destroy
    article = Article.find_by(slug: params[:slug])
    return forbidden unless article.user_id == @current_user.id
    article.destroy
    render json: {}, status: 200
  end

  def favorite
    article = Article.find_by(slug: params[:slug])
    render json: { "article": format_article(article) }, status: 200
  end

  def unfavorite
    article = Article.find_by(slug: params[:slug])
    render json: { "article": format_article(article) }, status: 200
  end

  def feed
    articles = []
    Article.all.includes(:user, :favorites).each do |a|
      articles.push(format_article(a))
    end

    render json: { articles: articles, articlesCount: 0 }, status: 200
  end
end
