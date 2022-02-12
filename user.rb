require_relative 'questions'

class User

    attr_accessor :id, :fname, :lname

    def self.find_by_id(id)
        user = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            users
        WHERE
            id = ?
        SQL
        return nil unless user.length > 0

        User.new(user.first)
    end

    def self.find_by_name(fname, lname)
        user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        SELECT
            *
        FROM
            users
        WHERE
            fname = ? AND lname = ?
        SQL
        return nil unless user.length > 0

        User.new(user.first)
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def authored_questions
        Question.find_by_author_id(@id)
    end

    def authored_replies
        Reply.find_by_user_id(@id)
    end

    def followed_questions 
        QuestionFollow.followed_questions_for_user_id(@id)
    end

    def liked_questions
        QuestionLike.liked_questions_for_user_id(@id)
    end

    def average_karma
        counts = QuestionsDatabase.instance.execute(<<-SQL, @id)
        SELECT
            COUNT(DISTINCT questions.id), COUNT(question_likes.id)
        FROM
            questions
        LEFT JOIN
            question_likes ON question_likes.question_id = questions.id
        WHERE
            questions.user_id = ?
        SQL

        question_count = counts[0]['COUNT(DISTINCT questions.id)']
        return 0 if question_count == 0
        likes_count = counts[0]['COUNT(question_likes.id)']
        likes_count/(question_count*1.0)
    end

    def save
        if self.id
            QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
            UPDATE
                users
            SET
                fname = ?, lname = ?
            WHERE
                id = ?
            SQL
        else
            QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
            INSERT INTO
                users (fname, lname)
            VALUES
                (?, ?)
            SQL
        end
    end
end