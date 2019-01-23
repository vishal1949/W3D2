require_relative 'everything'
require 'sqlite3'
require 'singleton'
class Replies
  attr_accessor :question_id, :reply_id, :user_id, :body 
  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM replies")
    data.map { |datum| Replies.new(datum) }
  end

  def self.find_by_id(id)
    replies = QuestionDBConnection.instance.execute(<<-SQL, id)
    SELECT
      * 
    FROM 
      replies
    WHERE
      id = ?
    SQL
    return nil unless replies.length > 0
    Replies.new(replies.first) 
  end 
  def self.find_by_user_id(user_id)
    replies = QuestionDBConnection.instance.execute(<<-SQL, user_id)
    SELECT
      * 
    FROM 
      replies
    WHERE
      user_id = ?
    SQL
    return nil unless replies.length > 0
    Questions.new(replies.first) 
  end 

  def self.find_by_question_id(id)
    replies = QuestionDBConnection.instance.execute(<<-SQL, id)
    SELECT
      * 
    FROM 
      replies
    WHERE
      question_id = ?
    SQL
    return nil unless replies.length > 0
    replies.map {|reply| Replies.new(reply)}
  end 
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @reply_id = options['reply_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def author
    Users.find_by_id(user_id)
  end  

  def question 
    Questions.find_by_id(question_id)
  end
  
  def parent_reply
    Replies.find_by_id(reply_id)
  end 

  def child_replies 
    replies = QuestionDBConnection.instance.execute(<<-SQL, @id)
    SELECT
      * 
    FROM 
      replies
    WHERE
      reply_id = ?
    SQL
    replies.map {|reply| Replies.new(reply)}
  end 

end