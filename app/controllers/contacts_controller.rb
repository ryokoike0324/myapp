class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def confirm
    @contact = Contact.new(contact_params)
    if @contact.invalid?
      flash[:alert] = @contact.errors.full_messages.join(', ')
      @contact = Contact.new
      render :new, status: :unprocessable_entity
    else
      render :confirm
    end
  end

  def back
    @contact = Contact.new(contact_params)
    render :new, status: :unprocessable_entity
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.contact_mail(@contact).deliver_now
      redirect_to done_contacts_path
    else
      flash[:alert] = @contact.errors.full_messages.join(", ")
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
