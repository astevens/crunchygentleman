CrunchyGentleman.controllers :galleries do
  get :index, :map => "/" do
    @galleries = Gallery.order_by([:created_at, :asc]).paginate(:per_page => 20, :page => params[:page])
    render 'galleries/index'
  end
  
  get :show, :with => :id do
    @gallery = Gallery.find(params[:id])
    render 'galleries/show'
  end
  
end