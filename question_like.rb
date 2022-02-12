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

    def self.likers_for_question_id(question_id)
        question = Question.find_by_id(question_id)
        raise "#{question_id} not found in DB" unless question

        users = QuestionsDatabase.instance.execute(<<-SQL, question.id)
        SELECT
            users.id, users.fname, users.lname
        FROM
            questions
        LEFT JOIN
            question_likes ON questions.id = question_likes.question_id
        JOIN
            users ON  question_likes.user_id = users.id
        WHERE
            questions.id = ?
        SQL

        users.map { |user| User.new(user) }
    end

    def self.num_likes_for_question_id(question_id)
        question = Question.find_by_id(question_id)
        raise "#{question_id} not found in DB" unless question

        count = QuestionsDatabase.instance.execute(<<-SQL, question.id)
        SELECT
            COUNT(question_likes.user_id)
        FROM
            questions
        LEFT JOIN
            question_likes ON questions.id = question_likes.question_id
        WHERE
            questions.id = ?
        SQL

        count.first["COUNT(question_likes.user_id)"]
    end

    def self.liked_questions_for_user_id(user_id)
        user = User.find_by_id(user_id)
        raise "#{user_id} not found in DB" unless user

        questions = QuestionsDatabase.instance.execute(<<-SQL, user.id)
        SELECT
            questions.id, questions.title, questions.body, questions.user_id
        FROM
            questions
        LEFT JOIN
            question_likes ON questions.id = question_likes.question_id
        WHERE
            question_likes.user_id = ?
        SQL

        questions.map { |question| Question.new(question) }
    end

    def self.most_liked_questions(n)
        questions = QuestionsDatabase.instance.execute(<<-SQL, n)
        SELECT
            DISTINCT questions.id, questions.title, questions.body, questions.user_id
        FROM
            questions
        LEFT JOIN
            question_likes ON question_likes.question_id = questions.id
        GROUP BY
            questions.id
        ORDER BY
            COUNT(question_likes.user_id) DESC
        LIMIT
            ?
        SQL

        questions.map { |question| Question.new(question) }
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

end