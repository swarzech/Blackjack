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
  
  def total
    return @@total
  end
  
  def total=(total)
    @@total = total
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

def print_player_total_cards(print_player)
  print("Player has " + print_player.show_card_one)
  print(" " + print_player.show_card_two)
  
  print_player.hit_cards.each { |x| print(" " + x.face.to_s + " " + x.suit.to_s)}
  print("\n")
  
  print(" Total : " + print_player.card_total.to_s + "\n")
end

def player_hits(hit_player)
  action = "H"
  while action == "H" do
    hit_player.hit(deck.shift)
    if hit_player.card_total > 21 then
      print("Bust\n")
      print_player_total_cards(hit_player)
      exit = true
      action = "B"
    else
      print_player_total_cards(hit_player)
      print("(H)it (S)tand (E)xit" + "\n")
      action = gets.to_s.strip
    end
  end
  return action
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
  print_player_total_cards(player)
  
  print("(H)it (S)tand (E)xit")
  
  if player.bet <= player.total then
    print(", (D)ouble down")
  end
  
  if player.can_split then
    print(", S(P)lit")
  end
  print("\n")
  action = gets.to_s.strip
  
  if action == "S" then
    print_player_total_cards(player)
    exit = true
    action = "S"
  elsif action == "H" then
    action = player_hits(player)
  elsif action == "P" then
    
  elsif action == "D" then
    player.double(deck.shift)
    print("Bet: " + player.bet.to_s + "\n")
    print("Amount avaliable: " + player.total.to_s + "\n")
    print_player_total_cards(player)
    exit = true
    action = player.card_total > 21 ? "B" : "S"
  elsif action == "E" then
    exit = true
  end
     
  
  if player.total == 0 then
    exit = true
  end
  
end

