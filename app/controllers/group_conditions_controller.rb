class GroupConditionsController < ApplicationController
  TOKYO_AREAS = [
    "新宿",
    "渋谷",
    "池袋",
    "吉祥寺",
    "中野",
    "東京駅",
    "上野",
    "恵比寿"
  ].freeze

  GENRES = [
    "和食",
    "洋食",
    "中華",
    "イタリアン",
    "フレンチ",
    "焼肉",
    "居酒屋",
    "カフェ"
  ].freeze
  # Step 1
  def area
    @group = Group.find(params[:group_id])
    @areas = TOKYO_AREAS
  end
  # Step 1 保存
  def save_area
    @group = Group.find(params[:group_id])

    @group.group_areas.destroy_all

    params[:areas].each do |area|
      next if area.blank?

      @group.group_areas.create!(area: area)
    end

    redirect_to group_conditions_genre_path(@group)
  end
  # Step 2
  def genre
    @group = Group.find(params[:group_id])
    @genres = GENRES
  end
  # Step 2 保存
  def save_genre
    @group = Group.find(params[:group_id])

    @group.group_genres.destroy_all

    params[:genres].each do |genre|
      next if genre.blank?

      @group.group_genres.create!(genre: genre)
    end

    redirect_to group_conditions_budget_path(@group)
  end
  # Step 3
  def budget
    @group = Group.find(params[:group_id])
  end
  # Step 3 保存
  def save_budget
    @group = Group.find(params[:group_id])

    @group.update!(budget: params[:budget])

    redirect_to group_conditions_ng_path(@group)
  end
  # Step 4
  def ng
    @group = Group.find(params[:group_id])
  end
  # Step 4 保存
  def save_ng
    @group = Group.find(params[:group_id])

    @group.group_ng_conditions.destroy_all

    params[:conditions]&.each do |condition|
      @group.group_ng_conditions.create!(
        condition: condition,
        status: "avoid"
      )
    end

    redirect_to group_path(@group)
  end
end
