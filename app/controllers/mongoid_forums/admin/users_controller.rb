require_dependency "mongoid_forums/application_controller"

module MongoidForums
  module Admin
    class UsersController < BaseController

      before_action :set_user, only: [:add_admin, :remove_admin]

      def index
        @admins = MongoidForums.user_class.where(mongoid_admin: true)
        @non_admins = MongoidForums.user_class.where(mongoid_admin: false)
      end

      def add_admin
        @user.mongoid_admin = true
        @user.save
        redirect_to admin_users_path
      end

      def remove_admin
        @user.mongoid_admin = false
        @user.save
        redirect_to admin_users_path
      end

      private

      def set_user
        @user = MongoidForums.user_class.find(params[:user][:id])
      end

    end
  end
end
