
module Juicy

  SCALE_TYPES = {
	  chromatic: [1,1,1,1,1,1,1,1,1,1,1,1],
	  whole_note: [2,2,2,2,2,2],
	  octotonic: [2,1,2,1,2,1,2,1],
	  pentatonic: [2,2,3,2,3],
	  diatonic: [2,2,1,2,2,2,1]
  }
  #            0  1  2  3  4  5  6  7  8  9 10 11 12
  #            |- |- |- |- |- |- |- |- |- |- |- |- |
  #           do di re ri mi fa fi so si la li ti do
  # chromatic  |- |- |- |- |- |- |- |- |- |- |- |- |
  #           do    re    mi fa    so    la    ti do
  # diatonic   |-  - |-  - |- |-  - |-  - |-  - |- |
  #           do    re    mi       so    la       do
  # pentatonic |-  - |-  - |-  -  - |-  - |-  -  - |
  #           do    re    mi    fi    si    li    do
  # whole note |-  - |-  - |-  - |-  - |-  - |-  - |
  #           do    re ri    fa fi    si la    ti do
  # octotonic  |-  - |- |-  - |- |-  - |- |-  - |- |
  #

  class Scale
    include Enumerable

    attr_reader :root, :mode, :notes

    def initialize(options = {mode: Mode.new, root: Note.new})
      options[:mode] ||= Mode.new
      options[:root] ||= Note.new
      case options[:mode].type
      when :major
      @type = :diatonic
      when :minor
      @type = :diatonic
      else
      @type = options[:mode].type
      end
      @mode = options[:mode]
      @root = options[:root]
      generate_notes

    end

    def to_s
      "scale type: #{@type}, mode: #{@mode}, root: #{@root}"
    end

    def[](element)

    end

    def play
      each_note(&:play)
    end

    def mode=(type)
      @mode = Mode.new(type)
      generate_notes
    end

    def root=(root)
      @root = root
      generate_notes
    end

    #def each
    #  yield SCALE_TYPES[@type]
    #end

    def each
      (SCALE_TYPES[@type].size+1).times do
        yield @notes.next.name
      end
    end

    def each_note &block
      if block_given?
        (SCALE_TYPES[@type].size+1).times do
          yield @notes.next
        end
      else
        @notes
      end
    end

    def interval_between(note, other_note)
      half_steps = 0
      direction = (note1 <=> note2)
      distance = 0
      until (note <=> other_note) == 0

      end
      if direction == 0
      elsif direction == -1
        note = note1.dup
        until (note <=> note2) == 0
          note += 1
          half_steps += 1
        end
      elsif direction == 1
        note = note1.dup
        until (note <=> note2) == 0
          note -= 1
          half_steps -= 1
        end
      end
      half_steps
    end

    def do
      if @mode == :major
        @root
      end
    end

    def re
      if @mode == :major
        @root + 2
      end
    end

    def mi
      if @mode == :major
        @root + 4
      end
    end

    def fa
      if @mode == :major
        @root + 5
      end
    end

    def so
      if @mode == :major
        @root + 7
      end
    end

    def la
      if @mode == :major
        @root + 9
      end
    end

    def ti
      if @mode == :major
        @root + 11
      end
    end

    def notes
      return @raw_notes if @raw_notes
      @raw_notes = []
      @raw_notes << @root
      SCALE_TYPES[@type].rotate(@mode.rotate).each do |step|
        @raw_notes << @raw_notes[-1] + step
      end
      @raw_notes
    end

    def include?(other_note)
      includes = false
      notes.each do |note|
        if note.name == other_note.name
          includes = true
          break
        end
      end
      includes
    end

    private

    def generate_notes
      @notes = []
      @notes << @root
      SCALE_TYPES[@type].rotate(@mode.rotate).each do |step|
        @notes << @notes[-1] + step
      end
      @notes = @notes.cycle
    end

  end

end
