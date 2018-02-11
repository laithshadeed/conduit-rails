class CommentsController < ApplicationController
  def index
    @article = Article.find_by(slug: params[:slug])
    render json: {"comments": Comment.where(article_id: @article.id)} , status: 200
  end

  def create
    @options = params.require(:comment).permit(:body)
    @options[:user] = User.find(1)
    @options[:article] = Article.find_by(slug: params[:slug])
    @comment = Comment.create(@options)
    @comment.save
    render json: {"created": "OK"}, status: 200
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    render json: {"destroy": "#{params[:id]}"}, status: 200
  end
end
