require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User

    attr_accessor

    def self.find_by_id

    end

    def initialize(options)

    end

end

class Question

    attr_accessor

    def self.find_by_id

    end

    def initialize(options)

    end

end

class QuestionFollow

    attr_accessor

    def self.find_by_id

    end

    def initialize(options)

    end

end

class Reply

    attr_accessor

    def self.find_by_id

    end

    def initialize(options)

    end

end

class QuestionLike

    attr_accessor

    def self.find_by_id

    end

    def initialize(options)

    end

end