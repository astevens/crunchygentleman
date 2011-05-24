CrunchyGentleman.controllers :media do
  get :show, :with => :id do
    @media = Media.find(params[:id])
    render 'media/show'
  end
end