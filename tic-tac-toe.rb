require 'pry'

class Board
  attr_accessor :board_marks

  @win_or_draw = false

  def initialize
    @board_marks = {
      row1: [" ", " ", " "],
      row2: [" ", " ", " "],
      row3: [" ", " ", " "]
    }
    
    join_rows()

    @board = "#{@row1}\n#{@row2}\n#{@row3}"
  end
  
  def start_game(cross, circle)
    until @win_or_draw
      player_turn(cross)
      player_turn(circle)
      check_if_restart_or_finish_game()
    end
  end

  def check_if_restart_or_finish_game
    if @win_or_draw
      user_answer = ask_player_restart_game()
      if user_answer
        restart_game()
      else
        win_or_draw = false
      end
    end
  end

  def ask_player_restart_game
    print "\nType \"yes\" to restart the game: "
    user_answer = gets.chomp
    user_answer == "yes"
  end

  def restart_game
    initialize()
    @win_or_draw = false
  end

  def player_turn(player_turn)
    return if @win_or_draw

    begin
      input = player_turn.get_player_input
      if check_invalid_move(input)
        while check_invalid_move(input)
          puts "\nInvalid move!"
          input = player_turn.get_player_input
        end
      end      
    rescue => exception
      puts "Invalid input"
      retry
    end
    

    write_move(input, player_turn.mark)
    check_game_state(player_turn.mark)

    puts "\n#{@board}\n"
  end

  def check_game_state(player_mark)
    if check_draw()
      @win_or_draw = true 
      puts "\nDraw!\n"
    elsif check_win(player_mark)
      @win_or_draw = true
      puts "\nPlayer #{player_mark} won!" if @win_or_draw
    end
  end

  def check_draw
    rows = flatten_board_hash
    @board_marks.each { |row, list| rows.concat(list) }

    rows.all? { |position| position != " " }
  end

  def flatten_board_hash(board_marks = @board_marks)
    rows = []
    board_marks.each { |row, list| rows.concat(list) }

    rows
  end

  def check_win(mark)
    rows = flatten_board_hash

    winning_positions = [
      [rows[0] == mark && rows[1] == mark && rows[2] == mark],
      [rows[3] == mark && rows[4] == mark && rows[5] == mark],
      [rows[6] == mark && rows[7] == mark && rows[8] == mark],
      [rows[0] == mark && rows[3] == mark && rows[6] == mark],
      [rows[1] == mark && rows[4] == mark && rows[7] == mark],
      [rows[2] == mark && rows[5] == mark && rows[8] == mark],
      [rows[0] == mark && rows[4] == mark && rows[8] == mark],
      [rows[2] == mark && rows[4] == mark && rows[6] == mark]
    ]
    
    winning_positions.any? { |position| position[0] == true }
  end

  def write_move(play, mark)
    @board_marks["row#{play[0]}".to_sym][play[1]] = mark

    join_rows()

    @board = "#{@row1}\n#{@row2}\n#{@row3}"
  end

  def check_invalid_move(play)
    @board_marks["row#{play[0]}".to_sym][play[1]] != " "
  end
  
  def join_rows
    @row1 = @board_marks[:row1].join("|")
    @row2 = @board_marks[:row2].join("|")
    @row3 = @board_marks[:row3].join("|")
  end
end

class Mark
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def get_player_input
    print "\nEnter row: "
    row = gets.chomp.to_i

    print "Enter column: "
    column = gets.chomp.to_i - 1

    [row, column]
  end
end

class Circle < Mark
  def initialize(mark)
    super(mark)
  end
end

class Cross < Mark
  def initialize(mark)
    super(mark)
  end
end

board = Board.new
cross = Cross.new("x")
circle = Circle.new("o")
#board.start_game(cross, circle)

