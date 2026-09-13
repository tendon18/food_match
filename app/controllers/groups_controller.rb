class GroupsController < ApplicationController
  def new
    @group = Group.new
  end

  def create
    @group = current_user.created_groups.build(group_params)

    if @group.save
      @group.group_members.create!(
        user: current_user,
        role: "organizer"
      )

      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end
