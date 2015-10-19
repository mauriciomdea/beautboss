class Api::V1::ReportsController < ApplicationController
  before_action :authenticate_user

  def create
    user = @current_user
    post = Post.find(params[:post_id])
    report = Report.new(post: post, user: user, explanation: report_params[:explanation])
    report.flag = report_params[:flag]
    if report.save
      render json: ReportSerializer.new(report).as_json(root: false),
        location: "/api/v1/posts/#{post.id}/reports/#{report.id}",
        status: :created
    else
      render json: { errors: report.errors.full_messages }, status: 422
    end
  rescue ActiveRecord::RecordNotFound
    render json: {error: "Not found"}, status: :not_found, root: false
  rescue => err
    render json: {error: err.to_s}, status: 422
  end

  private

    def report_params
      params.permit(:post_id, :flag, :explanation)
    end

end