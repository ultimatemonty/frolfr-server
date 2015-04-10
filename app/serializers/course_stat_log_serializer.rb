class CourseStatLogSerializer < ActiveModel::Serializer
  attributes :id, :total_scorecards_played, :completed_scorecards_played,
    :average_strokes, :best_strokes, :average_score, :best_score,
    :total_birdies, :total_pars, :total_bogeys, :total_eagles, :total_doubles_or_worse

  def id
    object.id
  end

  delegate :total_scorecards_played, :completed_scorecards_played,
    :average_strokes, :best_strokes, :average_score, :best_score,
    :total_birdies, :total_pars, :total_bogeys, :total_eagles, :total_doubles_or_worse, to: :stat_log

  private

  def stat_log
    @stat_log ||= CourseStatLog.new(user: scope, course: object)
  end
end