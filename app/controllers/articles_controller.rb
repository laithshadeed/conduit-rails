# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :authenticate, except: %i[index show]

  def index
    opts = params.permit(:tag, :author, :favorited, :limit, :offset)
    limit = opts[:limit] || 10
    offset = opts[:offset] || 0
    articles = []
    where = {}
    where[:tags] = Tag.where(name: opts[:tag]) unless opts[:tag].nil?
    where[:user] = User.find_by(username: opts[:author]) unless opts[:author].nil?
    Article
      .includes(:tags, :favorites, user: [:active_relationships])
      .where(where)
      .order(updated_at: :desc)
      .limit(limit)
      .offset(offset)
      .each do |a|
      articles.push(format_article(a))
    end

    render json: { "articles": articles, "articlesCount": Article.where(where).count }, status: 200
  end

  def feed
    opts = params.permit(:tag, :favorited, :limit, :offset)
    limit = opts[:limit] || 10
    offset = opts[:offset] || 0
    articles = []
    where = {}
    where[:tags] = Tag.where(name: opts[:tag]) unless opts[:tag].nil?
    where[:user] = Relationship.where(follower_id: @current_user.id).map(&:followed_id)
    Article
      .includes(:tags, :favorites, user: [:active_relationships])
      .joins(:user)
      .where(where)
      .order(updated_at: :desc)
      .limit(limit)
      .offset(offset)
      .each do |a|
      articles.push(format_article(a))
    end

    render json: { "articles": articles, "articlesCount": Article.where(where).count }, status: 200
  end

  def create
    opts = params.require(:article).permit(:title, :description, :body, tagList: [])
    article = Article.new(
      title: opts[:title],
      slug: opts[:title].downcase.tr(" ", "-"),
      description: opts[:description],
      body: opts[:body],
      user: @current_user
    )
    article.tags.build(opts[:tagList].map { |t| { name: t } })
    return server_error unless article.save
    render json: { "article": format_article(article) }, status: 200
  end

  def show
    article = format_article(Article.find_by(slug: params[:slug]))
    render json: { "article": article }, status: 200
  end

  def update
    article = Article.find_by(slug: params[:slug])
    return forbidden unless article.user_id == @current_user.id
    opts = params.require(:article).permit(:title, :description, :body, tagList: [])
    opts[:slug] = opts[:title].downcase.tr(" ", "-") unless opts[:title].nil?
    tag_list = opts.delete(:tagList)
    article.tags.build(tag_list.map { |t| { name: t } }) unless tag_list.nil?
    return server_error unless article.update(opts)
    render json: { "article": format_article(article) }, status: 200
  end

  def destroy
    article = Article.find_by(slug: params[:slug])
    return forbidden unless article.user_id == @current_user.id
    article.destroy
    render json: {}, status: 200
  end
end
