class DocumentsController < ApplicationController
  before_action :authenticate_user!, only: [:update, :new]

  def index
    @documents = Document.all
    if params[:query].present?
      session[:search_query] = params[:query]
      query = "%#{params[:query].downcase}%"
      @documents = @documents.where("LOWER(title) LIKE ? or LOWER(description) LIKE ?", query, query)
    end
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
    @document = Document.find(params[:id])
    @user = @document.user
    @versions = @document.versions
    session[:return_to] = params[:return_to] if params[:return_to].present?
  rescue ActiveRecord::RecordNotFound
    redirect_to documents_path, alert: 'Document not found.'
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])
    PaperTrail.request.whodunnit = current_user.id if current_user
    @document.update(document_params)
    return_to = session.delete(:return_to)
    if return_to&.include?(your_documents_path)
      redirect_to your_documents_path(query: session[:search_query]), notice: 'Document was successfully updated.'
    else
      redirect_to documents_path(query: session[:search_query]), notice: 'Document was successfully updated.'
    end
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
  end

  def your_documents
    @documents = Document.where(user: current_user)
    if params[:query].present?
      session[:search_query] = params[:query]
      query = "%#{params[:query].downcase}%"
      @documents = @documents.where("LOWER(title) LIKE ? or LOWER(description) LIKE ?", query, query)
    end
  end

  def versions
    @document = Document.find(params[:id])
    @versions = @document.versions
  end

  def lock
    @document = Document.find(params[:id])
    PaperTrail.request.whodunnit = current_user.id if current_user
    @document.update(locked: true)

    respond_to do |format|
      format.json { render json: { success: true } }
      format.html { redirect_to documents_path, notice: 'Document locked.' }
    end
  end

  def unlock
    @document = Document.find(params[:id])
    PaperTrail.request.whodunnit = current_user.id if current_user
    @document.update(locked: false)

    respond_to do |format|
      format.json { render json: { success: true } }
      format.html { redirect_to documents_path, notice: 'Document unlocked.' }
    end

  end

  private

  def document_params
    params.require(:document).permit(:image, :title, :description, :transcription, :user_id, :file)
  end

  def authenticate_user!
    unless user_signed_in?
      store_location_for(:user, request.fullpath) # Store the full path for redirect after login
      redirect_to new_user_session_path, alert: 'Please log in to continue.'
    end
  end

end
