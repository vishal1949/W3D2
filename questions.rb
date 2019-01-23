require 'sqlite3'
require 'singleton'
require_relative 'everything'

class QuestionDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Questions
  attr_accessor :title, :body, :author_id
  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM questions")
    data.map { |datum| Questions.new(datum) }
  end

  def self.find_by_id(id)
    question = QuestionDBConnection.instance.execute(<<-SQL, id)
    SELECT
      * 
    FROM 
      questions
    WHERE
      id = ?
    SQL
    return nil unless question.length > 0
    Questions.new(question.first) 
  end 

  def self.find_by_author_id(author_id)
    question = QuestionDBConnection.instance.execute(<<-SQL, author_id)
    SELECT
      * 
    FROM 
      questions
    WHERE
      author_id = ?
    SQL
    return nil unless question.length > 0
    Questions.new(question.first) 
  end 

  
  def self.find_by_title(title)
    question = QuestionDBConnection.instance.execute(<<-SQL, title)
    SELECT
    * 
    FROM 
    questions
    WHERE
    title = ?
    SQL
    return nil unless question.length > 0
    question.map {|q| Questions.new(q)}
    # Question.new(question.first) 
  end 

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLikes.most_liked_questions(n)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    Users.find_by_id(@author_id)
  end

  def replies
    Replies.find_by_question_id(@id) 
  end

  def followers
    QuestionFollows.followers_for_question_id(@id)
  end

  def likers 
    QuestionLikes.likers_for_question_id(@id)
  end 

  def num_likes
    QuestionLikes.num_likes_for_question_id(@id)
  end 
  
end



