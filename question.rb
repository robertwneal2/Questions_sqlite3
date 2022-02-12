require_relative 'questions'

class Question

    attr_accessor :id, :title, :body, :user_id

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            questions
        WHERE
            id = ?
        SQL
        return nil unless question.length > 0

        Question.new(question.first)
    end

    def self.find_by_author_id(author_id)
        user = User.find_by_id(author_id)
        raise "#{author_id} not found in DB" unless user

        questions = QuestionsDatabase.instance.execute(<<-SQL, user.id)
        SELECT
            *
        FROM
            questions
        WHERE
            user_id = ?
        SQL

        questions.map { |question| Question.new(question) }
    end

    def self.most_followed(n)
        QuestionFollow.most_followed_questions(n)
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

    def author 
        User.find_by_id(@user_id)
    end

    def replies
        Reply.find_by_question_id(@id)
    end

    def followers 
        QuestionFollow.followers_for_question_id(@id)
    end

    def likers 
        QuestionLike.likers_for_question_id(@id)
    end

    def num_likes
        QuestionLike.num_likes_for_question_id(@id)
    end

end