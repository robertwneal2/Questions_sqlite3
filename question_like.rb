require_relative 'questions'

class QuestionLike

    attr_accessor :id, :question_id, :user_id

    def self.find_by_id(id)
        question_like = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            question_likes
        WHERE
            id = ?
        SQL
        return nil unless question_like.length > 0

        QuestionLike.new(question_like.first)
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

end