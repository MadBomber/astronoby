# frozen_string_literal: true

RSpec.describe Astronoby::Radian do
  let(:instance) { described_class.new(Math::PI) }

  describe "#value" do
    subject { instance.value }

    it "returns the angle's numeric value in the current unit" do
      expect(subject).to eq(Math::PI)
    end
  end

  describe "#to_degrees" do
    subject { instance.to_degrees }

    it "returns a new Degree instance" do
      expect(subject).to be_a(Astronoby::Degree)
    end

    it "converted the degrees value into degrees" do
      expect(subject.value).to eq(180)
    end
  end

  describe "#to_radians" do
    subject { instance.to_radians }

    it "returns itself" do
      expect(subject).to eq(instance)
    end
  end
end
