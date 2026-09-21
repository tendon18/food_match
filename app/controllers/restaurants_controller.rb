class RestaurantsController < ApplicationController
  def new
    @group = Group.find(params[:group_id])

    @restaurant = Restaurant.new

    @group_genres = @group.group_genres
    @group_areas = @group.group_areas
  end

  def create
    @group = Group.find(params[:group_id])

    restaurant = Restaurant.create!(
      group: @group,
      added_by: current_user,
      name: params[:restaurant][:name],
      budget: params[:budget],
      group_genre_id: params[:group_genre_id],
      group_area_id: params[:group_area_id],
      features: params[:restaurant][:features],
      url: params[:restaurant][:url],
      memo: params[:restaurant][:memo]
    )

    redirect_to restaurant_complete_path(@group, restaurant)
  end

  def index
    @group = Group.find(params[:group_id])
    @restaurants = @group.restaurants
  end

  def complete
    @group = Group.find(params[:group_id])
    @restaurant = @group.restaurants.find(params[:id])
  end

  def show
    @group = Group.find(params[:group_id])
    @restaurant = @group.restaurants.find(params[:id])
  end
end
