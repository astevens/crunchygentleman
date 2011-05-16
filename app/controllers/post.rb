CrunchyGentleman.controllers :posts do
  get :index, :map => "/" do
    @posts = Post.order_by([:created_at, :asc]).paginate(:per_page => 20, :page => params[:page])
    flash[:error] = "Example error"
    flash[:information] = "Poop a doop!"
    render 'posts/index'
  end
  
  get :show, :with => :id do
    @post = Post.find(params[:id])
    render 'posts/show'
  end
  
end