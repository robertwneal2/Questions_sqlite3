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

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @user_id = options['user_id']
    end

end