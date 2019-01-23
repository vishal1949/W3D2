require_relative 'everything'
require 'sqlite3'
require 'singleton'
class Users
  attr_accessor :fname, :lname
  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM users")
    data.map { |datum| Users.new(datum) }
  end

  def self.find_by_id(id)
    user = QuestionDBConnection.instance.execute(<<-SQL, id)
    SELECT
      * 
    FROM 
      users
    WHERE
      id = ?
    SQL
    return nil unless user.length > 0
    Users.new(user.first) 
  end 
  
  def self.find_by_name(fname,lname)
    user = QuestionDBConnection.instance.execute(<<-SQL, fname, lname)
    SELECT
      * 
    FROM 
      users
    WHERE
      fname = ? AND lname = ?
    SQL
    return nil unless user.length > 0
    user.map {|q| Users.new(q)}
  end 


  def initialize(options) 
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_replies
    Replies.find_by_user_id(@id)
  end

  def authored_questions
    Questions.find_by_author_id(@id)
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(@id)
  end
  
  def liked_questions
    QuestionLikes.liked_questions_for_user_id(@id)
  end 

  def average_karma
    counts = QuestionDBConnection.instance.execute(<<-SQL, @id)
    SELECT
      COUNT(ql.id), COUNT(q.id) 
    FROM
      questions AS q
    JOIN question_likes AS ql
      ON ql.user_id = q.author_id
    WHERE
      q.author_id = ?
    SQL
    counts 
  end
end