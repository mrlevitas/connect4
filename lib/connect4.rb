require_relative "board"
require_relative "player"
require "pry"

class Connect4
  attr_reader :p1 , :p2, :current_player, :opponent

  def initialize
    @board = Board.new
    @p1 = nil
    @p2 = nil
  end

  def play
    puts "Welcome to Connect 4!\n\nThis game has two players.\nLet's start by getting the player names.\n\n"
    get_player_names
    while true
      game_play
      break unless play_again?
      @board.clear_board
    end
  end

  def get_player_names
    print "Enter name for first player: "
    p1_name = gets.chomp
    puts
    p2_name = names_unique?(p1_name)
    initialize_players(p1_name, p2_name)
  end

  def names_unique?(p1_name)
    print "Enter name for second player: "
    p2_name = gets.chomp
    puts
    while p1_name.downcase == p2_name.downcase
      print "Second player, please enter a different name than the first player: "
      p2_name = gets.chomp
      puts
    end
    p2_name
  end

  def initialize_players(p1_name, p2_name)
    @p1 = Player.new(p1_name, "X")
    @p2 = Player.new(p2_name, "O")
    @current_player = p1
    @opponent = p2
  end

  def game_play
    @player_counter = 0
    @board.print_grid
    print_legend
    current_player_turn
  end

  def current_player_turn
    while true
      break if board_full?
      break if player_plays_chip
    end
  end

  def board_full?
    flag = false
    if @board.grid_full?
      @board.print_grid
      print_legend
      flag = true
    end
    flag
  end

  def player_plays_chip
    flag = false
    column = prompt_player_choice.to_i
    if !@board.column_full?(column)
      row = @board.add_chip(current_player, column).to_i
      flag = winner?(row, column)
      return flag if flag
      switch_players
      @board.print_grid
      print_legend
    else
      puts "Colunn is full. Enter a different column."
    end
  end

  def prompt_player_choice
    print "#{current_player.name}, please enter a column (0-9) to drop your chip in: "
    choice = gets.chomp.downcase
    puts
    while choice.to_i > 9 || choice.to_i < 0 || !(/[a-z][a-z]*/ =~ choice).nil?
      print "Column does not exist, choose again: "
      choice = gets.chomp.downcase
      puts
    end
    choice.to_i
  end

  def winner?(row, column)
    flag = false
    if @board.winner?(row , column, opponent)
      @board.print_grid
      print_legend
      puts "#{current_player.name} wins!\n\n"
      flag = true
    end
    flag
  end

  def switch_players
    @player_counter += 1
    if @player_counter%2 == 0
      @current_player = p1
      @opponent = p2
    else
      @current_player = p2
      @opponent = p1
    end
  end

  def play_again?
    while true
      print 'Would you like to play again? (Y\N): '
      answer = gets.chomp.downcase
      if answer == "y"
        return true
      elsif answer == "n"
        return false
      else
        puts "Invalid input."
      end
    end
  end

  def print_legend
    puts "#{p1.name}: #{p1.chip}"
    puts "#{p2.name}: #{p2.chip}"
    puts
  end
end

game = Connect4.new
game.play
