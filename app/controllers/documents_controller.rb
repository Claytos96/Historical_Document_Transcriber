class DocumentsController < ApplicationController

  def index
    @documents = Document.all
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    @document.user = current_user
    @document.save!
    redirect_to root_path
  end

  def show
    @docuemnt = Document.find(params[:id])
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])
    @document.update(document_params)
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
  end

  private

  def document_params
    params.require(:document).permit(:image, :title, :description, :text, :user_id, :photo)
  end
end
