class OwnersController < ApplicationController
  before_action :set_owner, only: [:show, :edit, :update, :destroy]

  def index
    @owners = policy_scope(Owner).includes(:pets)
  end

  def show
    authorize @owner
  end

  def new
    @owner = Owner.new
    authorize @owner
  end

  def create
    @owner = Owner.new
    
    @owner.assign_attributes(permitted_attributes(@owner))
    
    authorize @owner

    if @owner.save
      redirect_to @owner, notice: "Owner was created"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @owner
  end

  def update
    authorize @owner
    
    if @owner.update(permitted_attributes(@owner))
      redirect_to @owner, notice: "Owner was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @owner
    @owner.destroy
    redirect_to owners_url, notice: "Owner was deleted."
  end

  private

  def set_owner
    @owner = Owner.find(params[:id])
  end

end