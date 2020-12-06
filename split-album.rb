#!/usr/bin/ruby

require 'optparse'
require_relative 'track'
require_relative 'timestamp'

def parseTime(time_s)
  m_s = time_s.split(":")
  Timestamp.new(m_s[0].to_i, m_s[1].to_i)
end

def main
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: split-album.rb [options]"
    opts.on("-t", "--timestamps TIMESTAMPS_FILE", "Timestamps file") do |tf|
      options[:timestamps_file] = tf
    end
    opts.on("-a", "--audio AUDIO_FILE", "Audio file") do |af|
      options[:audio_file] = af
    end
  end.parse!

  if options[:timestamps_file] == nil || options[:audio_file] == nil
      puts "Error while parsing arguments... See usage for more info."
  end

  # parse input file for splitting into Track classes

  tracks = []

  File.readlines(options[:timestamps_file]).each do |line|
    parts = line.split("-")
    parts[1] = parts[1][1..parts[1].length-2]
    tracks.push(Track.new(parts[1], parseTime(parts[0])))
  end

  p tracks

  # got the tracks -> split mp3 file
  for i in 0..tracks.length
    if i == (tracks.length - 1)
      # last track => only one param
      `ffmpeg -i #{options[:audio_file]} -acodec copy -ss #{tracks[i].timestamp.to_seconds} \"#{tracks[i].name}.mp3\"`
    else
      # two params
      `ffmpeg -i #{options[:audio_file]} -acodec copy -ss #{tracks[i].timestamp.to_seconds} -to #{tracks[i+1].timestamp.to_seconds} \"#{tracks[i].name}.mp3\"`
    end
  end
end

main