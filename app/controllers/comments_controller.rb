# frozen_string_literal: true

class CommentsController < ApplicationController
  def index
    @article = Article.find_by(slug: params[:slug])
    @comments = []
    Comment.includes(:user).where(article_id: @article.id).each do |c|
      @comments.push(format(c))
    end
    render json: { "comments": @comments }, status: 200
  end

  def create
    @options = params.require(:comment).permit(:body)
    @options[:user] = User.find(1)
    @options[:article] = Article.find_by(slug: params[:slug])
    @comment = Comment.create(@options)
    @comment.save
    render json: { "comment": format(@comment) }, status: 200
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    render json: {}, status: 200
  end

  private

  def format(c)
    {
      id: c.id,
      createdAt: c.created_at,
      updatedAt: c.updated_at,
      body: c.body,
      author: {
        username: c.user.username,
        bio: c.user.bio,
        image: c.user.image,
        following: false # TODO
      }
    }
  end
end
