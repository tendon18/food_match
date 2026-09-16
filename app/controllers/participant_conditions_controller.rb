class ParticipantConditionsController < ApplicationController
  def new
    @group = Group.find(params[:group_id])

    @group_member = @group.group_members.find(params[:group_member_id])

    @participant_condition = ParticipantCondition.new

    @group_genres = @group.group_genres
    @group_areas = @group.group_areas
    @group_avoid_conditions = @group.group_avoid_conditions
  end

  def create
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])

    participant_condition = ParticipantCondition.create!(
      group_member: @group_member,
      budget: params[:budget]
    )

    params[:genre_ids]&.each do |genre_id|
      participant_condition.participant_condition_genres.create!(
        group_genre_id: genre_id
      )
    end

    params[:area_ids]&.each do |area_id|
      participant_condition.participant_condition_areas.create!(
        group_area_id: area_id
      )
    end

    params[:avoid_condition_ids]&.each do |avoid_id|
      participant_condition.participant_condition_avoids.create!(
        group_avoid_condition_id: avoid_id
      )
    end

    redirect_to participant_condition_complete_path(@group, @group_member)
  end

  def edit
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])

    @participant_condition = @group_member.participant_condition

    @group_genres = @group.group_genres
    @group_areas = @group.group_areas
    @group_avoid_conditions = @group.group_avoid_conditions
  end

  def update
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])

    participant_condition = @group_member.participant_condition

    participant_condition.update!(
      budget: params[:budget]
    )

    participant_condition.participant_condition_genres.destroy_all

    params[:genre_ids]&.each do |genre_id|
      participant_condition.participant_condition_genres.create!(
        group_genre_id: genre_id
      )
    end

    participant_condition.participant_condition_areas.destroy_all

    params[:area_ids]&.each do |area_id|
      participant_condition.participant_condition_areas.create!(
        group_area_id: area_id
      )
    end

    participant_condition.participant_condition_avoids.destroy_all

    params[:avoid_condition_ids]&.each do |avoid_id|
      participant_condition.participant_condition_avoids.create!(
        group_avoid_condition_id: avoid_id
      )
    end

    redirect_to participant_condition_complete_path(@group, @group_member)
  end

  def complete
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @group_members = @group.group_members
  end
end
