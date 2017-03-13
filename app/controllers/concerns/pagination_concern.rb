# PaginationConcern
module PaginationConcern
  extend ActiveSupport::Concern

  # This methods paginates a Generic Array object
  def paginate_results(records, current_page, total_count, per_page = 5)
    return nil if records.blank?
    records = Kaminari.paginate_array(records, total_count: total_count.to_i)
                      .page(current_page.to_i)
                      .per(per_page)
    records
  end
end
