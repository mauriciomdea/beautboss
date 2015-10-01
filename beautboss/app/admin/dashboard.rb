ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  # content title: proc{ I18n.t("active_admin.dashboard") } do
  #   div class: "blank_slate_container", id: "dashboard_default_message" do
  #     span class: "blank_slate" do
  #       span I18n.t("active_admin.dashboard_welcome.welcome")
  #       small I18n.t("active_admin.dashboard_welcome.call_to_action")
  #     end
  #   end
  # end

    content title: proc{ I18n.t("active_admin.dashboard") } do

        # panel "Info" do
        #   para "Welcome to ActiveAdmin."
        # end

        columns do

          column do

            panel "Latest Users" do
            
                table do
                    User.order("created_at desc").limit(5).map do |user|
                        tr do
                            td image_tag user.avatar, size: '32x32'
                            td "#{time_ago_in_words user.created_at} ago"
                            td link_to(user.name, admin_user_path(user))
                            td user.email
                        end
                    end
                end
                span link_to "Manage all users...", admin_users_path

            end

          end

          column max_width: "170px", min_width: "170px" do

            panel "Latest Registers" do

                table do
                    Post.order("created_at desc").limit(5).map do |register|
                        tr do 
                            td link_to image_tag(register.image, size: '128x128', alt: register.user.name), admin_register_path(register)
                        end
                    end
                end
                span link_to "Manage all registers...", admin_registers_path

            end

          end

        end

        # panel "Latest Registers" do
            
        # end

        # panel "Recent Users" do
            
        # end

    end

end
