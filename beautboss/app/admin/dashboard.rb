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

    columns do

      column max_width: "800px", min_width: "800px" do

        panel link_to 'Latest registers', admin_registers_path do

          Post.order("created_at desc").limit(5).map do |register|
            span link_to image_tag(register.image, size: '150x150', alt: register.user.name), admin_register_path(register)
          end
            
        end

        panel link_to 'Latest reports', admin_reports_path do

          Report.order("created_at desc").limit(5).map do |report|
            span link_to image_tag(report.post.image, size: '150x150', alt: report.user.name), admin_register_path(report.post)
          end
            
        end

        panel "Latest registered users" do

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

        end

      end # left column

      column max_width: "160px", min_width: "160px" do

        panel "Metrics" do
          h2 "#{User.count} users"
          h2 "#{Post.count} registers"
        end

      end # right column

    end # columns

  end # content

end # dashboard
