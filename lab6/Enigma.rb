# frozen_string_literal: true

module Enigma
  ALPHABET = %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z).freeze

  class Plugboard

    attr_accessor :mappings

    def initialize()
      self.mappings = {}
    end

    def plug(a, b)
      self.mappings[a] = b
      self.mappings[b] = a
    end

    def swap(letter)
      self.mappings[letter] || letter
    end
  end

  class Reflector

    module Mappings
      DEFAULT = %w[Y R U H Q S L D P X N G O K M I E B F Z C W V J A T].freeze
    end

    module Position
      DEFAULT = 0
    end

    def initialize(mappings: Mappings::DEFAULT, position: Position::DEFAULT)
      @mappings = mappings
      @position = position
    end

    def reflect(letter)
      return letter unless ALPHABET.include?(letter)

      ALPHABET[(@mappings.index(letter) + @position) % ALPHABET.length]
    end

  end

  class Rotor
    module Mappings
      DEFAULT = ALPHABET
      A = %w[E K M F L G D Q V Z N T O W Y H X U S P A I B R C J].freeze
      B = %w[A J D K S I R U X B L H W T M C Q G Z N P Y F V O E].freeze
      C = %w[B D F H J L C P R T X V Z N Y E I W G A K M U S Q O].freeze
    end

    module Turnover
      DEFAULT = 0
      A = Mappings::A.index('R')
      B = Mappings::B.index('F')
      C = Mappings::C.index('W')
    end

    module Position
      DEFAULT = 0
    end

    module Offset
      DEFAULT = 0
    end

    def initialize(mappings: Mappings::DEFAULT, turnover: Turnover::DEFAULT, position: Position::DEFAULT)
      @mappings = mappings
      @turnover = turnover
      @position = position
      reset!
    end

    def rotate
      @offset = @offset.next % ALPHABET.length
      self
    end

    def turnover?
      ((@position + @offset) % ALPHABET.length).eql?(@turnover)
    end

    def forward(letter)
      return letter unless ALPHABET.include?(letter)

      @mappings[(ALPHABET.index(letter) + @position + @offset) % ALPHABET.length]
    end

    def reverse(letter)
      return letter unless ALPHABET.include?(letter)

      ALPHABET[(@mappings.index(letter) + @position - @offset) % ALPHABET.length]
    end

    def reset!
      @offset = Offset::DEFAULT
    end

    def self.rotors
      [
        new(mappings: Mappings::A, turnover: Turnover::A),
        new(mappings: Mappings::B, turnover: Turnover::B),
        new(mappings: Mappings::C, turnover: Turnover::C),
      ]
    end

  end

  class Machine
    SEPARATOR = ''.freeze

    def initialize(rotors: Rotor.rotors, reflector: Reflector.new, plugboard: Plugboard.new)
      @rotors = rotors
      @reflector = reflector
      @plugboard = plugboard
    end

    def convert(string)
      format(string).split(SEPARATOR).map { |character| process(character) }.join(SEPARATOR)
    end

    def reset!
      @rotors.each(&:reset!)
    end

    private

    def process(character)
      rotate

      [
        method(:plug),
        method(:forward),
        method(:reflect),
        method(:reverse),
        method(:plug),
      ].reduce(character) { |current, operation| operation.call(current) }
    end

    def format(string)
      string.upcase
    end

    def plug(character)
      @plugboard.swap(character)
    end

    def reflect(character)
      @reflector.reflect(character)
    end

    def forward(character)
      @rotors.inject(character) do |memo, rotor|
        rotor.forward(memo)
      end
    end

    def reverse(character)
      @rotors.reverse.inject(character) do |memo, rotor|
        rotor.reverse(memo)
      end
    end

    def rotate
      @rotors.each do |rotor|
        rotor.rotate
        break unless rotor.turnover?
      end
    end
  end
end

