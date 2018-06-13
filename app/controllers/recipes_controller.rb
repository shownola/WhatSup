class RecipesController < ApplicationController
  before_action :find_recipe, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  def index
    @recipes = Recipe.paginate(page: params[:page], per_page: 5)
  end
  
  def show
    @comment = Comment.new
    @comments = @recipe.comments.paginate(page: params[:page], per_page: 5)
  end
  
  def new
    @recipe = Recipe.new
    @recipe.recipe_ingredients.build
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = current_chef
    if @recipe.save
      flash[:success] = "Recipe has been created"
      redirect_to recipe_path(@recipe)
    else
      render 'new'
    end
  end
  
  def edit
   @recipe.recipe_ingredients.build
  end
  
  def update
   
    if @recipe.update(recipe_params)
      flash[:success] = "Recipe has been updated"
      redirect_to recipe_path(@recipe)
    else
      render 'edit'
    end
  end
  
  def destroy
    Recipe.find(params[:id]).destroy
    flash[:success] = 'Recipe has been deleted successfully'
    redirect_to recipes_path
  end
  
  private
  
     def find_recipe
      @recipe = Recipe.find(params[:id])
     end
  
    def recipe_params
      params.require(:recipe).permit(:name, :directions, ingredients_attributes: Ingredient.attribute_names.map(&:to_sym).push(:_destroy))
      # params.require(:recipe).permit(:name, :directions, recipe_ingredients_attributes: Ingredient.attribute_names.map(&:to_sym).push(:_destroy))
    end
    
    def require_same_user
      if current_chef != @recipe.chef and !current_chef.admin?
        flash[:danger] = 'You can only edit or delete your own recipes'
        redirect_to recipes_path
      end
    end
    
   
  
end

# params.require(:todo_list).permit(:name, tasks_attributes: [:id, :_destroy,:todo_list_id,:name,:completed,:due])
# params.require(:todo_list).permit(:name, tasks_attributes: Task.attribute_names.map(&:to_sym).push(:_destroy))
 