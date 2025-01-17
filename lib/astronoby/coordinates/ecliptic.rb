# frozen_string_literal: true

module Astronoby
  module Coordinates
    class Ecliptic
      attr_reader :latitude, :longitude

      def initialize(latitude:, longitude:)
        @latitude = latitude
        @longitude = longitude
      end

      # Source:
      #  Title: Celestial Calculations
      #  Author: J. L. Lawrence
      #  Edition: MIT Press
      #  Chapter: 4 - Orbits and Coordinate Systems
      def to_equatorial(epoch:)
        mean_obliquity = MeanObliquity.for_epoch(epoch)

        y = Angle.as_radians(
          @longitude.sin * mean_obliquity.cos -
          @latitude.tan * mean_obliquity.sin
        )
        x = Angle.as_radians(@longitude.cos)
        r = Angle.atan(y.radians / x.radians)
        right_ascension = Util::Trigonometry.adjustement_for_arctangent(y, x, r)

        declination = Angle.asin(
          @latitude.sin * mean_obliquity.cos +
          @latitude.cos * mean_obliquity.sin * @longitude.sin
        )

        Equatorial.new(
          right_ascension: right_ascension,
          declination: declination,
          epoch: epoch
        )
      end
    end
  end
end
