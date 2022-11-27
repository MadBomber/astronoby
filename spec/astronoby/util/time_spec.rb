# frozen_string_literal: true

RSpec.describe Astronoby::Util::Time do
  describe "::ut_to_gst" do
    it "returns a BigDecimal" do
      expect(
        described_class.ut_to_gst(Time.new)
      ).to be_an_instance_of(BigDecimal)
    end

    context "from a real-life example (2014-12-12 20:00:00 UTC)" do
      it "computes the right time (8h 41m 53s)" do
        gst = described_class.ut_to_gst(Time.utc(2010, 2, 7, 23, 30, 0))

        hour = gst.to_i
        minute = (gst - hour) * 60
        second = (minute - minute.to_i) * 60

        expect(gst.to_i).to eq(8)
        expect(minute.to_i).to eq(41)
        expect(second.to_i).to eq(53)
      end
    end

    context "from a real-life example (2000-07-05 07:00:00 UTC)" do
      it "computes the right time (1h 54m 20s)" do
        gst = described_class.ut_to_gst(Time.utc(2000, 7, 5, 7, 0, 0))

        hour = gst.to_i
        minute = (gst - hour) * 60
        second = (minute - minute.to_i) * 60

        expect(gst.to_i).to eq(1)
        expect(minute.to_i).to eq(54)
        expect(second.to_i).to eq(20)
      end
    end
  end

  describe "::local_sidereal_time" do
    it "returns a BigDecimal" do
      expect(
        described_class.local_sidereal_time(time: Time.new, longitude: 1)
      ).to be_an_instance_of(BigDecimal)
    end

    context "from a real-life example (77° W on 2014-12-12 20:00:00)" do
      it "computes the right time (1h 18m 34s)" do
        local_sidereal_time = described_class.local_sidereal_time(
          time: Time.new(2014, 12, 12, 20, 0, 0, "-05:00"),
          longitude: BigDecimal("-77")
        )

        hour = local_sidereal_time.to_i
        minute = (local_sidereal_time - hour) * 60
        second = (minute - minute.to_i) * 60

        expect(local_sidereal_time.to_i).to eq(1)
        expect(minute.to_i).to eq(18)
        expect(second.to_i).to eq(34)
      end
    end

    context "from a real-life example (60° E on 2000-07-05 12:00:00)" do
      it "computes the right time" do
        local_sidereal_time = described_class.local_sidereal_time(
          time: Time.new(2000, 7, 5, 12, 0, 0, "+05:00"),
          longitude: BigDecimal("60")
        )

        hour = local_sidereal_time.to_i
        minute = (local_sidereal_time - hour) * 60
        second = (minute - minute.to_i) * 60

        expect(local_sidereal_time.to_i).to eq(5)
        expect(minute.to_i).to eq(54)
        expect(second.to_i).to eq(20)
      end
    end
  end
end
