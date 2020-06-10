require "pry"

class Board
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
      break if @win_or_draw
      player_turn(circle)
    end
  end

  def player_turn(player_turn)
    input = player_turn.get_player_input
    write_move_to_board(input, player_turn.mark)
    check_win(player_turn.mark)
  end

  def check_win(mark)
    rows = []
    @board_marks.each { |row, list| rows.concat(list) }

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
    
    check_winning_position?(winning_positions)
  end

  def check_winning_position?(positions)
    if positions.any? { |position| position[0] == true }
      puts "\nPlayer #{mark} won!"
      @win_or_draw = true
    end
  end

  def write_move_to_board(play, mark)
    @board_marks["row#{play[0]}".to_sym][play[1]] = mark

    join_rows()

    @board = "#{@row1}\n#{@row2}\n#{@row3}"
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

board.start_game(cross, circle)