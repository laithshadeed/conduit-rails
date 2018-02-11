class ArticlesController < ApplicationController
  def index
    @articles = Article.all
    render json: {"articles": @articles, "articlesCount": @articles.count} , status: 200
  end

  def create
    @options = params.require(:article).permit(:title, :description, :body)
    @options[:user] = User.find(1)
    @options[:slug] = @options[:title].downcase.tr(' ' , '-')
    @article = Article.new(@options)
    @article.save
    render json: {"created": "ok"}, status: 200
  end

  def show
    render json: {"article": Article.find_by(slug: params[:slug])}, status: 200
  end

  def update
    @article = Article.find_by(slug: params[:slug])
    @article.update(params.require(:article).permit(:title, :description, :body))
    render json: {"updated": "#{params[:slug]}"}, status: 200
  end

  def destroy
    @article = Article.find_by(slug: params[:slug])
    @article.destroy
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
