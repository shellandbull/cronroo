require "spec_helper"

RSpec.describe CronRoo::Expression do
  let(:units) { CronRoo::EXPRESSION_UNITS }

  describe "#value" do
    subject do
      described_class.new(input: input, unit: unit)
    end

    context "with just an expression" do
      let(:input) { "*" }
      let(:unit) { units.find { |u| :minute == u[:unit] } }

      it "returns the expected value" do
        expect(subject.value).to eq((0..59).to_a)
      end
    end

    context "with a value list" do
      let(:input) { "1,5" }
      let(:unit) { units.find { |u| :hour == u[:unit] } }

      it "returns the expected value" do
        expect(subject.value).to eq([1, 5])
      end
    end

    context "with just a value" do
      let(:input) { "3" }
      let(:unit) { units.find { |u| :day_of_the_month == u[:unit] } }

      it "returns the expected value" do
        expect(subject.value).to eq([3])
      end
    end

    context "with an expression and a step expression" do
      let(:input) { "*/2" }
      let(:unit) { units.find { |u| :day_of_the_month == u[:unit] } }

      it "returns the expected value" do
        expect(subject.value).to eq((1..31).step(2).to_a)
      end
    end

    context "with a range of values" do
      let(:input) { "8-14" }
      let(:unit) { units.find { |u| :minute == u[:unit] } }

      it "returns the expected value" do
        expect(subject.value).to eq((8..14).to_a)
      end
    end

    context "with 2 expressions" do
      let(:input) { "0-20/2" }
      let(:unit) { units.find { |u| :day_of_the_month == u[:unit] } }

      it "returns the expected value" do
        expect(subject.value).to eq([0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20])
      end
    end

    context "with more than 2 expressions" do
      let(:input) { "1,10,20" }
      let(:unit) { units.find { |u| :day_of_the_month == u[:unit] } }

      it "returns the expected value" do
        expect(subject.value).to eq([1, 10, 20])
      end
    end

    context "with more than 2 composite expressions" do
      let(:input) { "8,10-11,*/3" }
      let(:unit) { units.find { |u| :hour == u[:unit] } }

      it "returns the expected value" do
        expect(subject.value).to eq([8, 10, 11, 0, 3, 6, 9, 12, 15, 18, 21])
      end
    end
  end
end
