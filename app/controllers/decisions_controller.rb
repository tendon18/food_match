class DecisionsController < ApplicationController
  def show
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @restaurant = @group.restaurants.find(params[:restaurant_id])
  end

  def update
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])

    return redirect_to group_path(@group), alert: "幹事のみ店舗を決定できます" unless @group.creator == current_user

    restaurant = @group.restaurants.find(params[:restaurant_id])

    @group.update!(decided_restaurant_id: restaurant.id)

    redirect_to group_decision_complete_path(
      @group,
      group_member_id: @group_member.id
    )
  end

  def complete
    @group = Group.find(params[:group_id])
    @restaurant = @group.restaurants.find(@group.decided_restaurant_id)
  end
end
