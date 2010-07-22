class GoogleFormsController < ApplicationController
  
  def index
    @google_forms = GoogleForm.all
  end
  
  def new
    @google_form = GoogleForm.new
  end
  
  def edit
    @google_form = GoogleForm.find(params[:id])
  end

  def update
    @google_form = GoogleForm.find(params[:id])
    if @google_form.update_attribtes(params[:google_form])
      flash[:notice] = "Your form '#{@google_form.title}' has been successfully updated."
      redirect_to google_forms_path
    else
      flash.now[:error] = "We could not update your form"
      render :edit
    end
  end
  
  def create
    @google_form = GoogleForm.new(params[:google_form])
    if @google_form.save
      flash[:notice] = "Your form '#{@google_form.title}' has been successfully created."
      redirect_to google_forms_path
    else
      flash.now[:error] = "We could not create your form"
      render :new
    end
  end
  
  def destroy
    @google_form = GoogleForm.find(params[:id])
    @google_form.destroy
    flash[:notice] = "Your form has been removed"
    redirect_to google_forms_path
  end
  
end
