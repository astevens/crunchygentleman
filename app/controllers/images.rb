CrunchyGentleman.controllers :images do
  get :index do
    @images = Media::Image.all
    render 'images/index'
  end
  
  get :show, :with => :id do
    @image = Media::Image.find params[:id]
    render 'images/show'
  end
  
  get :new do
    @image = Media::Image.new
    render 'images/new'
  end
  
  post :create do
    @image = Media::Image.new(params[:media_image])
    if @image.save
      flash[:notice] = "Image added!"
      redirect url(:images, :index)
    else
      flash[:error] = "Nope."
      render url(:images, :new)
    end
  end
      
end