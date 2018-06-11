class IngredientsController < ApplicationController
  before_action :find_ingredient, only: [:show, :edit, :udpate]
  
  def index
    @ingredients = Ingredient.paginate(page: params[:page], per_page: 25)
  end
  
  def show
    @ingredient_recipes = @ingredient.recipes.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @ingredient = Ingredient.new
  end
  
  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      flash[:success] = 'Ingredient successfully created'
      redirect_to ingredient_path(@ingredient)
    else
      render 'new'
    end
  end
  
  def edit
    
  end
  
  def update
    if @ingredient.update(ingredient_params)
      flash[:success] = "ingredient name was upated successfully"
      redirect_to @ingredient
    else
      render 'edit'
    end
  end
  
  private
  
  def ingrdient_params
    params.require(:ingredient).permit(:name)
  end
  
  def find_ingredient
    @ingredient = Ingredient.find(params[:id])
  end



  
end