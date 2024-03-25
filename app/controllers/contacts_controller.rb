class ContactsController < ApplicationController
  # before_action :contact_params, only: :confirm

  def new
    session.delete(:contact_params)
    @contact = Contact.new
  end

  def back
    if session[:contact_params]
      @contact = Contact.new(session[:contact_params])
      render :new, status: :unprocessable_entity
    else
      render :new
    end
  end

  def confirm
    # binding.remote_pry
    session[:contact_params] = contact_params if params[:contact].present?
    @contact = Contact.new(session[:contact_params])
    if @contact.invalid?
      # flash.now[:alert] = @contact.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    else
      render :confirm
    end
  end


  def create
    @contact = Contact.new(session[:contact_params])
    if @contact.save
      session.delete(:contact_params)
      ContactMailer.contact_mail(@contact).deliver_now
      redirect_to done_contacts_path
    else
      # flash.now[:alert] = @contact.errors.full_messages.join(', ')
      @contact = Contact.new
      render :new, status: :unprocessable_entity
    end
  end

  def done
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message)
  end
end
