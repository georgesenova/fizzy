module BucketViewsHelper
  def bucket_view_form(path, method:, id:)
    form_tag path, method: method, id: id do
      concat hidden_field_tag(:order_by, params[:order_by])
      concat hidden_field_tag(:status, params[:status])

      Array(params[:assignee_ids]).each do |assignee_id|
        concat hidden_field_tag(nil, assignee_id, name: "assignee_ids[]")
      end

      Array(params[:tag_ids]).each do |tag_id|
        concat hidden_field_tag(nil, tag_id, name: "tag_ids[]")
      end
    end
  end
end
