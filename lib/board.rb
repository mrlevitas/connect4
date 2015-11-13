require_relative 'cell'
require_relative 'player'
require 'pry'


class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(10){Array.new(10).map {Cell.new}}
  end

  def column_full?(column)
   flag = true
   grid.each { |row| flag = false if row[column].fill.nil? }
   flag
  end

  def grid_full?
    flag = true
    10.times {|i| flag = false if !column_full?(i)}
    puts "Board is full. No winner.\n" if flag
    flag
  end

  def winner? (row, column, opponent)
    flag = false
    flag = true if winner_x?(row, column, opponent) >= 4
    return_counted_to_nil
    flag = true if winner_y?(row, column, opponent) >= 4
    return_counted_to_nil
    flag = true if winner_incline_diag?(row, column, opponent) >= 4
    return_counted_to_nil
    flag = true if winner_decline_diag?(row, column, opponent) >= 4
    return_counted_to_nil
    flag
  end

  def winner_x?(row, column, opponent)
    if @grid[row][column].fill.nil? || @grid[row][column].fill == opponent.chip || @grid[row][column].counted == "counted"
      return 0
    end
    count = 1
    @grid[row][column].counted = "counted"
    count+= winner_x?(row, column+1, opponent) if column < 9
    count+= winner_x?(row, column-1, opponent) if column > 0
    count
  end

  def winner_y?(row, column, opponent)
    if @grid[row][column].fill.nil? || @grid[row][column].fill == opponent.chip || @grid[row][column].counted == "counted"
      return 0
    end
    count = 1
    @grid[row][column].counted = "counted"
    count+= winner_y?(row+1, column, opponent) if row < 9
    count+= winner_y?(row-1, column, opponent) if row > 0
    count
  end

  def winner_incline_diag?(row, column, opponent)
    if @grid[row][column].fill.nil? || @grid[row][column].fill == opponent.chip || @grid[row][column].counted == "counted"
      return 0
    end
    count = 1
    @grid[row][column].counted = "counted"
    count+= winner_incline_diag?(row+1, column+1, opponent) if row < 9 && column < 9
    count+= winner_incline_diag?(row-1, column-1, opponent) if row > 0 && column > 0
    count
  end

  def winner_decline_diag?(row, column, opponent)
    if @grid[row][column].fill.nil? || @grid[row][column].fill == opponent.chip || @grid[row][column].counted == "counted"
      return 0
    end
    count = 1
    @grid[row][column].counted = "counted"
    count+= winner_decline_diag?(row-1, column+1, opponent) if row > 0 && column < 9
    count+= winner_decline_diag?(row+1, column-1, opponent) if row < 9 && column > 0
    count
  end

  def return_counted_to_nil
    grid.each do |row|
      row.each do |cell|
        cell.counted = nil unless cell.counted.nil?
      end
    end
  end

  def clear_board
    @grid = Array.new(10){Array.new(10).map{Cell.new}}
  end

  def print_grid
    print " "
    10.times { print " _" }
    puts
    grid.each do |row|
      print "| "
      row.each do |cell|
        cell.fill.nil? ? (print "  ") : (print "#{cell.fill} ")
      end
      puts "|"
    end
    print " "
    10.times { print " -" }
    puts
    print " "
    10.times { |i| print " #{i}" }
    puts "\n\n"
  end

  def add_chip(current_player , column)
    counter = 9
    while counter >= 0
      if grid[counter][column].fill.nil?
        grid[counter][column].fill = current_player.chip
        return counter
        break
      end
      counter-=1
    end
  end
end
