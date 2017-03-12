class InquiriesController < ApplicationController
  before_action :set_inquiry, only: [:show, :update, :destroy]
  wrap_parameters :inquiry, include: ['title', 'question']
  before_action :authenticate_user!
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index]

  def index
    authorize Inquiry
    @inquiries = policy_scope(Inquiry.all)
    @inquiries = InquiryPolicy.merge(@inquiries)
  end

  def show
    authorize @inquiry
    inquiries = policy_scope(Inquiry.where(:id=>@inquiry.id))
    @inquiry = ImagePolicy.merge(inquiries).first
  end

  def create
    authorize Inquiry
    @inquiry = Inquiry.new(inquiry_params)
    @inquiry.customer_id=current_user.id

    User.transaction do
      if @inquiry.save
        role=current_user.add_role(Role::ORGANIZER, @inquiry)
        @inquiry.user_roles << role.role_name
        role.save!
        render :show, status: :created, location: @inquiry
      else
        render json: {errors:@inquiry.errors.messages}, status: :unprocessable_entity
      end
    end
  end

  def update
    authorize @inquiry

    if @inquiry.update(inquiry_params)
      head :no_content
    else
      render json: {errors:@inquiry.errors.messages}, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @inquiry
    @inquiry.destroy

    head :no_content
  end

  private

    def set_inquiry
      @inquiry = Inquiry.find(params[:id])
    end

    def inquiry_params
      params.require(:inquiry).permit(:title, :question)
    end
end
