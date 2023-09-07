# frozen_string_literal: true

# Handles the characteristics of the board where the game is played
class Board
  WINNING_COMBINATIONS = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                          [0, 3, 6], [1, 4, 7], [2, 5, 8],
                          [6, 4, 2], [0, 4, 8]].freeze

  def initialize
    @board = Array.new(9, ' ')
  end

  def show_board
    puts
    print("#{@board[0]} | #{@board[1]} | #{@board[2]}\n")
    print("---------\n")
    print("#{@board[3]} | #{@board[4]} | #{@board[5]}\n")
    print("---------\n")
    print("#{@board[6]} | #{@board[7]} | #{@board[8]}\n")
    puts
  end

  def update_board(position, sign)
    @board[position - 1] = sign
    show_board
  end

  def clear_board
    @board = Array.new(9, '#')
  end

  def valid_move?(position)
    !taken?(position) && !out_of_range?(position)
  end

  def taken?(position)
    @board[position - 1] == 'X' || @board[position - 1] == 'O'
  end

  def out_of_range?(position)
    !(position - 1).between?(0, 8)
  end

  def full?
    @board.all? { |position| %w[X O].include?(position) }
  end

  def winner?
    WINNING_COMBINATIONS.any? do |combo|
      combo.all? { |position| @board[position] == 'X' } || combo.all? { |position| @board[position] == 'O' }
    end
  end
end

# Handles player actions in the the game
class Player
  @@players = 0
  attr_reader :name, :sign

  def initialize(sign)
    @sign = sign
    @@players += 1
    puts "Player #{@@players}: Enter your name"
    @name = gets.chomp.capitalize
  end

  def place_sign(board)
    player_choice = choose_position
    if board.valid_move?(player_choice)
      board.update_board(player_choice, @sign)
      return
    end

    puts 'Invalid entry'
    place_sign(board)
  end

  def choose_position
    puts "#{@name}, pick a position from 1 - 9"
    gets.chomp.to_i
  end
end

# Handles the entire set of behaviours in the game
class TicTacToe
  def initialize
    @game_over = false
    @board = Board.new
    display_guide
    return unless players_ready?

    setup_players
    play_game
  end

  private

  def display_guide
    puts "\t\t----------------     1 | 2 | 3
                TIC - TAC - TOE      4 | 5 | 6
                ________________     7 | 8 | 9

                TO WIN AT TIC - TAC - TOE,
                YOU NEED TO GET THREE PLAYER SIGNS IN A ROW,
                THREE IN A COLUMN, OR THREE DIAGONALLY

                PLAYER ONE SIGN: 'X', PLAYER TWO SIGN: 'O'.

                YOU CAN PLACE YOUR SIGN IN ANY POSITION BETWEEN
                1 TO 9.
    "
  end

  def replay_game
    @board = Board.new
    @board.show_board
    @game_over = false
    play_game if replay?
  end

  def play_game
    play_round(@player_one)
    return replay_game if @game_over

    play_round(@player_two)
    return replay_game if @game_over

    play_game
  end

  def play_round(player)
    player.place_sign(@board)
    if @board.winner?
      puts "#{player.name} wins!"
      @game_over = true
    elsif @board.full?
      puts "It's a tie"
      @game_over = true
    end
  end

  def replay?
    puts "Wanna play again? Enter 'Y' for yes or 'N' for no"
    answer = gets.chomp.upcase
    return answer == 'Y' if %w[Y N].include?(answer)

    puts "Invalid answer: #{answer}"
    replay?
  end

  def players_ready?
    puts "Are you ready? Enter 'Y' for yes or 'N' for no"
    answer = gets.chomp.upcase
    return answer == 'Y' if %w[Y N].include?(answer)

    puts "Invalid answer: #{answer}"
    players_ready?
  end

  def setup_players
    @player_one = Player.new('X')
    @player_two = Player.new('O')
    puts "Alright! It's #{@player_one.name} against #{@player_two.name}. lets roll!"
  end
end
