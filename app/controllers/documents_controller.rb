class DocumentsController < ApplicationController

  def index
    @documents = Document.all
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)
    @document.save
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
    params.require(:document).permit(:image, :title, :description, :text, :user_id)
  end
end
