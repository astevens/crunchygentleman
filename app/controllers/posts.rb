CrunchyGentleman.controllers :posts do
  get :index, :map => "/" do
    @posts = Post.order_by([:created_at, :asc]).paginate(:per_page => 20, :page => params[:page])
    render 'posts/index'
  end
  
  get :show, :with => :id do
    @post = Post.find(params[:id])
    render 'posts/show'
  end
  
  delete :destroy, :with => :id do
    @post = Post.find(params[:id])
    name = @post.description
    @post.destroy
    redirect url(:posts, :index), :flash => {:notice => "#{name} deleted."}
  end
  
end