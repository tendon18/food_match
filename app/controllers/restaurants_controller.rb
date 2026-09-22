class RestaurantsController < ApplicationController
  def new
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])

    @restaurant = Restaurant.new

    @group_genres = @group.group_genres
    @group_areas = @group.group_areas
  end

  def create
    @group = Group.find(params[:group_id])

    group_member = @group.group_members.find(params[:group_member_id])

    restaurant = Restaurant.create!(
      group: @group,
      added_by: group_member,
      name: params[:restaurant][:name],
      budget: params[:budget],
      group_genre_id: params[:group_genre_id],
      group_area_id: params[:group_area_id],
      features: params[:restaurant][:features],
      url: params[:restaurant][:url],
      memo: params[:restaurant][:memo]
    )

    redirect_to restaurant_complete_path(
      @group,
      restaurant,
      group_member_id: group_member.id
    )
  end

  def index
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find_by(role: "organizer")
    @restaurants = @group.restaurants
  end

  def complete
    @group = Group.find(params[:group_id])
    @restaurant = @group.restaurants.find(params[:id])
  end

  def show
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @restaurant = @group.restaurants.find_by(id: params[:id])

    unless @restaurant
      redirect_to group_restaurants_index_path(
        @group,
        group_member_id: @group_member.id
      ) and return
    end
  end

  def edit
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @restaurant = @group.restaurants.find(params[:id])

    unless @restaurant.added_by == @group_member
      redirect_to restaurant_path(
        @group,
        @restaurant,
        group_member_id: @group_member.id
      ) and return
    end

    @group_genres = @group.group_genres
    @group_areas = @group.group_areas
  end

  def update
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @restaurant = @group.restaurants.find(params[:id])

    unless @restaurant.added_by == @group_member
      redirect_to restaurant_path(
        @group,
        @restaurant,
        group_member_id: @group_member.id
      ) and return
    end

    @restaurant.update!(
      name: params[:name],
      budget: params[:budget],
      group_genre_id: params[:group_genre_id],
      group_area_id: params[:group_area_id],
      features: params[:features],
      url: params[:url],
      memo: params[:memo]
    )

    redirect_to restaurant_path(
      @group,
      @restaurant,
      group_member_id: @group_member.id
    )
  end

  def destroy
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @restaurant = @group.restaurants.find(params[:id])

    unless @restaurant.added_by == @group_member
      redirect_to restaurant_path(
        @group,
        @restaurant,
        group_member_id: @group_member.id
      ) and return
    end

    @restaurant.destroy!

    redirect_to group_restaurants_index_path(
      @group,
      group_member_id: @group_member.id
    )
  end
end
