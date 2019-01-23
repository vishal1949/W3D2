require_relative 'everything'
require 'sqlite3'
require 'singleton'
class QuestionLikes
  attr_accessor :user_id, :question_id 
  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| QuestionLikes.new(datum) }
  end

  def self.find_by_id(id)
    question_likes = QuestionDBConnection.instance.execute(<<-SQL, id)
    SELECT
      * 
    FROM 
      question_likes
    WHERE
      id = ?
    SQL
    return nil unless question_likes.length > 0
    QuestionLikes.new(question_likes.first) 
  end 

  def self.likers_for_question_id(question_id)
    users = QuestionDBConnection.instance.execute(<<-SQL, question_id)
    SELECT
      u.id, u.fname, u.lname
    FROM 
      question_likes as ql
    JOIN users as u
      ON ql.user_id = u.id
    WHERE 
      ql.question_id = ?
    SQL
    return nil unless users.length > 0
    users.map {|user| Users.new(user)}
  end

  def self.num_likes_for_question_id(question_id)
    questions = QuestionDBConnection.instance.execute(<<-SQL, question_id)
    SELECT
      COUNT(*)
    FROM
      question_likes as ql
    WHERE 
       ql.question_id = ?
    SQL
    return nil unless questions.length > 0
    questions[0].values[0]
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
    SELECT
      q.id, q.title, q.body, q.author_id
    FROM 
      question_likes as ql
    JOIN questions as q
      ON q.id = ql.question_id
    WHERE 
      ql.user_id = ?
    SQL
    return nil unless questions.length > 0
    questions.map {|question| Questions.new(question)}
  end

  def self.most_liked_questions(n)
    questions = QuestionDBConnection.instance.execute(<<-SQL, n)
    SELECT
      COUNT(q.author_id) as num_likes, q.title, q.body, q.author_id, q.id
    FROM
      question_likes as ql
    JOIN questions as q 
      ON ql.question_id = q.id
    GROUP BY
      ql.question_id
    ORDER BY 
      num_likes DESC
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