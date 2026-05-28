class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :edit, :update, :destroy]

  def index
    @pets = policy_scope(Pet)
  end

  def show
    authorize @pet
  end

  def new
    @pet = Pet.new
    authorize @pet
  end

  def create
    @pet = Pet.new
    
    @pet.owner = current_user.owner if current_user.owner?
    
    @pet.assign_attributes(permitted_attributes(@pet))
    
    authorize @pet
    
    if @pet.save
      redirect_to @pet, notice: "Pet was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @pet
  end

  def update
    authorize @pet
    
    if @pet.update(permitted_attributes(@pet))
      redirect_to @pet, notice: "Pet was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @pet
    @pet.destroy
    redirect_to pets_url, notice: "Pet was deleted."
  end

  private

  def set_pet
    @pet = Pet.find(params[:id])
  end

end