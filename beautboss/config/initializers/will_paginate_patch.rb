# Pagination missing on rails_admin views
# https://codedecoder.wordpress.com/2013/06/19/pagination-missing-rails_admin-index-view-monkey-patching-gems/

if defined?(WillPaginate)
  module WillPaginate
    module ActiveRecord
      module RelationMethods
        # def per(value = nil)
        #   per_page(value)
        # end
        # def total_count()
        #   count
        # end
        alias_method :per, :per_page
        alias_method :num_pages, :total_pages
        alias_method :total_count, :count
      end
    end
    module CollectionMethods
      alias_method :num_pages, :total_pages
    end
  end
end