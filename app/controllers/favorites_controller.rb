# frozen_string_literal: true

class FavoritesController < ApplicationController
  before_action :authenticate

  def create
    article = Article.find_by(slug: params[:slug])
    can_create = Favorite.create(article_id: article.id, user_id: @current_user.id)
    return server_error unless can_create
    render json: { "article": format_article(article) }, status: 200
  end

  def destroy
    article = Article.find_by(slug: params[:slug])
    favorite = Favorite.find_by(article_id: article.id, user_id: @current_user.id)
    return server_error unless favorite.destroy
    render json: { "article": format_article(article) }, status: 200
  end
end
