require_relative 'everything'
require 'sqlite3'
require 'singleton'

class QuestionFollows
  attr_accessor :user_id, :question_id
  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| QuestionFollows.new(datum) }
  end

  def self.find_by_id(id)
    question_follows = QuestionDBConnection.instance.execute(<<-SQL, id)
    SELECT
      * 
    FROM 
      question_follows
    WHERE
      id = ?
    SQL
    return nil unless question_follows.length > 0
    QuestionFollows.new(question_follows.first) 
  end 


  def self.followers_for_question_id(question_id)
    users = QuestionDBConnection.instance.execute(<<-SQL, question_id)
    SELECT
      u.id, fname, lname 
    FROM 
      question_follows as q
    JOIN Users as u
      ON u.id = q.user_id
    WHERE 
      q.question_id = ?
    SQL
    return nil unless users.length > 0
    users.map {|user| Users.new(user)}
  end 

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
    SELECT
      q.id, q.title, q.body, q.author_id
    FROM 
      question_follows as qf
    JOIN questions as q
      ON qf.question_id = q.id
    WHERE 
      qf.user_id = ?
    SQL
    return nil unless questions.length > 0
    questions.map {|question| Questions.new(question)}
  end 

  def self.most_followed_questions(n)
    questions = QuestionDBConnection.instance.execute(<<-SQL, n)
    SELECT
      COUNT(q.author_id) as num_followers, q.title, q.body, q.author_id, q.id
    FROM
      question_follows as qf
    JOIN questions as q 
      ON qf.question_id = q.id
    GROUP BY
      qf.question_id
    ORDER BY 
      num_followers DESC
    LIMIT ? 
    SQL
    return nil unless questions.length > 0
    questions.map {|question| Questions.new(question)}
  end
  
  
  
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end

