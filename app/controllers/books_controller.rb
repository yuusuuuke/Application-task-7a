class BooksController < ApplicationController
before_action :ensure_user,only: [:edit,:update,:destroy]

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @books = Book.new
    @post_comments = PostComment.all
    @post_comment = PostComment.new
  end

  def index
    # @books = Book.all
    @book = Book.new
    # いいね順に並べるための追記
    @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.delete
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end


def ensure_user
  @books = current_user.books
  @book = @books.find_by(id: params[:id])  #.find_by:
  redirect_to books_path unless @book
end  