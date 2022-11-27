# frozen_string_literal: true

module Astronoby
  module Util
    module Time
      class << self
        def ut_to_gst(universal_time)
          # Julian Day
          julian_day = universal_time.to_date.ajd.to_f
          julian_day_at_beginning_of_the_year = ::Time.utc(universal_time.year, 1, 1, 0, 0, 0).to_date.ajd - 1
          number_of_elapsed_days_into_the_year = julian_day - julian_day_at_beginning_of_the_year

          # Source:
          #  Title: Celestial Calculations
          #  Author: J. L. Lawrence
          #  Edition: MIT Press
          #  Chapter: 3 - Time Conversions
          t = (julian_day_at_beginning_of_the_year - BigDecimal("2415020")) / BigDecimal("36525")
          r = BigDecimal("6.6460656") +
            BigDecimal("2400.051262") * t + BigDecimal("0.00002581") * t * t
          b = 24 - r + 24 * (universal_time.year - 1900)
          t0 = BigDecimal("0.0657098") * number_of_elapsed_days_into_the_year - b
          ut = universal_time.hour +
            universal_time.min / BigDecimal("60") +
            universal_time.sec / BigDecimal("3600")
          greenwich_sidereal_time = t0 + BigDecimal("1.002738") * ut

          # If greenwich_sidereal_time negative, add 24 hours to the date
          # If greenwich_sidereal_time is greater than 24, subtract 24 hours from the date

          greenwich_sidereal_time += 24 if greenwich_sidereal_time.negative?
          greenwich_sidereal_time -= 24 if greenwich_sidereal_time > 24

          greenwich_sidereal_time
        end

        def local_sidereal_time(time:, longitude:)
          universal_time = time.utc
          greenwich_sidereal_time = ut_to_gst(universal_time)

          adjustment = longitude / BigDecimal("15")
          greenwich_sidereal_time + adjustment
        end
      end
    end
  end
end