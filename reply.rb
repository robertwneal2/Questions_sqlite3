class Reply

    attr_accessor :id, :question_id, :parent_id, :user_id, :body

    def self.find_by_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            replies
        WHERE
            id = ?
        SQL
        return nil unless reply.length > 0

        Reply.new(reply.first)
    end

    def self.find_by_user_id(user_id)
        user = User.find_by_id(user_id)
        raise "#{user_id} not found in DB" unless user
        
        replies = QuestionsDatabase.instance.execute(<<-SQL, user.id)
        SELECT
            *
        FROM
            replies
        WHERE
            user_id = ?
        SQL

        replies.map { |reply| Reply.new(reply) }
    end

    def self.find_by_question_id(question_id)
        question = Question.find_by_id(question_id)
        raise "#{question_id} not found in DB" unless question
        
        replies = QuestionsDatabase.instance.execute(<<-SQL, question.id)
        SELECT
            *
        FROM
            replies
        WHERE
            question_id = ?
        SQL

        replies.map { |reply| Reply.new(reply) }
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_id = options['parent_id']
        @user_id = options['user_id']
        @body = options['body']
    end

end