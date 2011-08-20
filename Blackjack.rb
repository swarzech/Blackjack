class Card
  attr_accessor(:value, :face, :suit)
  
  def initialize(value, face, suit)
    @value = value
    @face = face
    @suit = suit
  end
end

class Player
  attr_accessor(:card_one, :card_two, :card_total)
  attr_accessor(:stand, :hit_cards, :bet)
  @@total = 200
  
  def initialize()
    @hit_cards = []
    @stand = false
  end
    
  def show_card_one()
    return @card_one.face.to_s + " " + @card_one.suit.to_s
  end
  
  def show_card_two()
    return @card_two.face.to_s + " " + @card_two.suit.to_s
  end
  
  def print_cards()
    print("Player has " + show_card_one)
    print(" " + show_card_two)

    @hit_cards.each { |x| print(" " + x.face.to_s + " " + x.suit.to_s)}
    print("\n")

    print(" Total : " + @card_total.to_s + "\n")
  end
  
  def hit(card)
    @hit_cards << card
    @card_total = @card_total + card.value
  end
  
  def split(card)
    @cord_two = card
    @card_total = @card_one.value + @card_two.value
  end
  
  def can_split()
    return @card_one.face.to_s == @card_two.face.to_s
  end
  
  def double(card)
    @hit_cards << card
    @card_total = @card_total + card.value
    @@total = @@total - @bet
    @bet = @bet * 2
    @stand = true
  end
  
  def has_ace()
    if (@card_one.face == "A" and @card_one.value == 11) or
       (@card_two.face == "A" and @card_two.value == 11) then
      return true
    end
    
    result = false
    @hit_cards.each{|x| result = x.face == "A" and x.value == 11 ? true : result}
    return result
  end
  
  def reset_ace()
    if @card_one.face == "A" and @card_one.value == 11 and @card_total > 21 then
      @card_one.value = 1
      @card_total = @card_total - 10
    elsif @card_two.face == "A" and @card_two.value == 11 and @card_total > 21 then
      @card_two.value = 1
      @card_total = @card_total - 10
    else
      for x in @hit_cards
        if x.face == "A" and x.value == 11 and @card_total > 21 then
          x.value = 1
          @card_total = @card_total - 10
        end
      end
    end
  end
  
  def total
    return @@total
  end
  
  def total=(total)
    @@total = total
  end
  
  def hit_action(deck)
    action = "H"
    result = "U"
    while action == "H" and result == "U" do
      hit(deck.shift)
      if @card_total > 21 and not has_ace then
        result = "B"
      else
        if @card_total > 21 and has_ace then
          reset_ace
        end
        print_cards
        print("(H)it (S)tand (E)xit" + "\n")
        action = gets.to_s.strip
        result = action == "H" ? "U" : action
      end
    end
    return result
  end
end

class Dealer
  attr_accessor(:card_one, :card_two, :card_total)
  attr_accessor(:hit, :stand)
  
  def initialize()
    @hit = []
    @stand = false 
    #@card_total > 17 or (@card_total == 17 and (@card_one["face"] != "A" or @card_two["face"] != "A"))
  end
    
  def show_card_one()
    return @card_one.face.to_s + " " + @card_one.suit.to_s
  end
  
  def show_card_one_value()
    return @card_one.value.to_s
  end
  
  def show_card_two()
    return @card_two.face.to_s + " " + @card_two.suit.to_s
  end
  
  def show_card_two_value()
    return @card_two.value.to_s
  end
  
  def hit(card)
    @hit << card
    @card_total = @card_total + card.value
  end
end

#setup deck
suits = ["Dimonds", "Hearts", "Spades", "Clubs"]

deck = []
discarddeck = [] 
exit = false

for j in suits
  for i in 2..10
    card = Card.new(i, i, j)
    deck << card
  end
  card = Card.new(10, "J", j)
  deck << card
  card = Card.new(10, "Q", j)
  deck << card
  card = Card.new(10, "K", j)
  deck << card
  card = Card.new(11, "A", j)
  deck << card
end

deck = deck.shuffle

while not exit do
  if deck.length < 10 then
    while deck.length > 0 do
      discarddeck << deck.shift
    end
    deck = discarddeck.shuffle
    discarddeck = []
  end
  
  dealer = Dealer.new()
  player = Player.new()
  print("Amount avaliable: " + player.total.to_s + "\n")
  bet = -1
  until bet > 0 and bet <= player.total do
    print("Place bet: ")
    bet = gets.to_i
  end
  player.bet = bet
  player.total = player.total - bet
  print("\n" + "Bet: " + player.bet.to_s + "\n")
  print("Amount avaliable: " + player.total.to_s + "\n")
  
  player.card_one = deck.shift
  player.card_total = player.card_one.value
  dealer.card_one = deck.shift
  player.card_two = deck.shift
  player.card_total = player.card_total + player.card_two.value
  dealer.card_two = deck.shift
  
  print("Dealer has " + dealer.show_card_two + " showing Total : " + dealer.show_card_two_value + "\n")
  player.print_cards
  
  print("(H)it (S)tand (E)xit")
  
  if player.bet <= player.total then
    print(", (D)ouble down")
  end
  
  if player.can_split then
    print(", S(P)lit")
  end
  print("\n")
  action = gets.to_s.strip
  
  result = "U"
  if action == "S" then
    player.print_cards
    result = "S"
  elsif action == "H" then
    result = player.hit_action(deck)
  elsif action == "P" then
    
  elsif action == "D" then
    player.double(deck.shift)
    print("Bet: " + player.bet.to_s + "\n")
    print("Amount avaliable: " + player.total.to_s + "\n")
    player.print_cards
    result = player.card_total > 21 ? "B" : "S"
  elsif action == "E" then
    exit = true
  end
  
  if result == "B" then
    print("Bust\n")
    player.print_cards
  elsif result == "S" then
    player.print_cards
  elsif result == "E" then
    exit = true
  end
     
  
  if player.total == 0 then
    exit = true
  end
  
end

