require_dependency "mongoid_forums/application_controller"

module MongoidForums
  module Admin
    class GroupsController < BaseController

      def index
        @groups = Group.all
      end

      def new
        @group = Group.new
      end

      def create
        @group =  Group.new(params.require(:group).permit(:name, :moderator, :members))
        if @group.save
          flash[:notice] = t("mongoid_forums.admin.group.created")
          redirect_to [:admin, @group]
        else
          flash[:notice] = t("mongoid_forums.admin.group.not_created")
          render :action => "new"
        end
      end

      def edit
        @group = Group.find(params[:id])
      end

      def update
        @group = Group.find(params[:id])
        if @group.update_attributes(params.require(:group).permit(:name, :members))
          flash[:notice] = t("mongoid_forums.admin.group.updated")
          redirect_to [:admin, @group]
        else
          flash[:notice] = t("mongoid_forums.admin.group.not_updated")
          render :action => "edit"
        end
      end

      def show
        @group = Group.find(params[:id])
        @group_members = @group.members.map{|member_id| MongoidForums.user_class.find(member_id) }
        @users = MongoidForums.user_class.all.select{ |user| !@group.members.include?(user.id) }
      end

      def destroy
        @group = Group.find(params[:id])
        @group.destroy
        flash[:notice] = t("mongoid_forums.admin.group.deleted")
        redirect_to admin_groups_path
      end

      ### Temporary Methods - Try Not To Cringe Too Much <3 ###
      def add_member
        group = Group.find(params.require(:group_id))
        user = MongoidForums.user_class.find(params[:user][:id])

        group.members << user.id unless group.members.include?(user.id)
        group.save

        redirect_to admin_group_path(group)
      end

      def remove_member
        group = Group.find(params.require(:group_id))
        user = MongoidForums.user_class.find(params[:user][:id])

        group.members.delete(user.id)
        group.save

        redirect_to admin_group_path(group)
      end
      #########################################################
    end

    private

    def group_params
      params.require(:group).permit(:name, :members)
    end
  end
end
