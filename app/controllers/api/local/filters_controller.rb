class Api::Local::FiltersController < Api::Local::BaseController

  def create_or_update
    filter = current_user.filter || current_user.build_filter
    filter.update(filter_params)

    city_ids = params.require(:filter).permit(:city_ids)[:city_ids].split(', ').map(&:to_i)
    filter.process_cities! city_ids

    topic_ids = params.require(:filter).permit(:topic_ids)[:topic_ids].split(', ').map(&:to_i)
    filter.process_topics! topic_ids

    render json: { success: true }
  end

  private

  def filter_params
    params.require(:filter).permit(:started_at, :finished_at)
  end
end
