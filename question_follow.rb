require_relative 'questions'

class QuestionFollow

    attr_accessor :id, :question_id, :user_id

    def self.find_by_id(id)
        question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            question_follows
        WHERE
            id = ?
        SQL
        return nil unless question_follow.length > 0

        QuestionFollow.new(question_follow.first)
    end

    def self.followers_for_question_id(question_id)
        question = Question.find_by_id(question_id)
        raise "#{question_id} not found in DB" unless question

        users = QuestionsDatabase.instance.execute(<<-SQL, question.id)
        SELECT
            users.id, users.fname, users.lname
        FROM
            question_follows
        JOIN
            users ON question_follows.user_id = users.id
        WHERE
            question_follows.question_id = ?
        SQL

        users.map { |user| User.new(user) }
    end

    def self.followed_questions_for_user_id(user_id)
        user = User.find_by_id(user_id)
        raise "#{user_id} not found in DB" unless user

        questions = QuestionsDatabase.instance.execute(<<-SQL, user.id)
        SELECT
            questions.id, questions.title, questions.body, questions.user_id
        FROM
            question_follows
        JOIN
            questions ON question_follows.question_id = questions.id
        WHERE
            question_follows.user_id = ?
        SQL

        questions.map { |question| Question.new(question) }
    end

    def self.most_followed_questions(n) #lists questions without any follow. use regular 'JOIN' to remove this feature
        questions = QuestionsDatabase.instance.execute(<<-SQL, n)
        SELECT
            DISTINCT questions.id, questions.title, questions.body, questions.user_id
        FROM
            questions
        LEFT JOIN
            question_follows ON question_follows.question_id = questions.id
        GROUP BY
            questions.id
        ORDER BY
            COUNT(question_follows.user_id) DESC
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