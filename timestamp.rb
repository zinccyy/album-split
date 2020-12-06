class Timestamp
    def initialize(min, sec)
        @minutes = min
        @seconds = sec
    end

    def sec
        @seconds
    end

    def minutes
        @minutes
    end

    def to_seconds
        @minutes * 60 + @seconds
    end
end