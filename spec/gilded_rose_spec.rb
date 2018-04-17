require 'spec_helper'
require 'gilded_rose'

RSpec.describe "#update_quality" do
  context "with a single item" do
    let(:initial_sell_in) { 5 }
    let(:initial_quality) { 10 }
    let(:item) do
      {
        name:    name,
        sell_in: initial_sell_in,
        quality: initial_quality
      }
    end

    context "For Normal item" do
      let(:name) { "NORMAL ITEM" }
      context "Update Sell in" do
        it { expect(update_quality([item])[0][:sell_in]).to eq(initial_sell_in-1) }
      end

      context "Before item sell date" do
        it { expect(update_quality([item])[0][:quality]).to eq(initial_quality-1) }
      end

      context "On item sell date" do
        let(:initial_sell_in) { 0 }
        it { expect(update_quality([item])[0][:quality]).to eq(initial_quality-2) }
      end

      context "After item sell date" do
        let(:initial_sell_in) { -10 }
        it { expect(update_quality([item])[0][:quality]).to eq(initial_quality-2) }
      end

      context "Zero Quality" do
        let(:initial_quality) { 0 }
        it { expect(update_quality([item])[0][:quality]).to eq(0) }
      end
    end

    context "For Aged Brie Item" do
      let(:name) { "Aged Brie" }
      
      context "Update Sell in" do
        it { expect(update_quality([item])[0][:sell_in]).to eq(initial_sell_in-1) }
      end

      context "Before item sell date" do

        context "Update Quality" do
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality+1) }
        end

        context "Max quality" do
          let(:initial_quality) { 50 }
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality) }
        end
      end

      context "On item sell date" do
        let(:initial_sell_in) { 0 }

        context "Updated Quality" do
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality+2) }
        end

        context "Near maximum quality" do
          let(:initial_quality) { 49 }
          it { expect(update_quality([item])[0][:quality]).to eq(50) }
        end

        context "Maximum quality" do
          let(:initial_quality) { 50 }
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality) }
        end
      end

      context "After item sell date" do
        let(:initial_sell_in) { -10 }

        context "Updated Quality" do
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality+2) }
        end

        context "Max quality" do
          let(:initial_quality) { 50 }
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality) }
        end
      end
    end

    context "For Sulfuras Item" do
      let(:initial_quality) { 80 }
      let(:name) { "Sulfuras, Hand of Ragnaros" }

      context "Updated Sell in Date" do
        it { expect(update_quality([item])[0][:sell_in]).to eq(initial_sell_in) }
      end

      context "Before item sell date" do
        it { expect(update_quality([item])[0][:quality]).to eq(initial_quality) }
      end

      context "On item sell date" do
        let(:initial_sell_in) { 0 }
        it { expect(update_quality([item])[0][:quality]).to eq(initial_quality) }
      end

      context "After item sell date" do
        let(:initial_sell_in) { -10 }
        it { expect(update_quality([item])[0][:quality]).to eq(initial_quality) }
      end
    end

    context "For Backstage pass item" do
      let(:name) { "Backstage passes to a TAFKAL80ETC concert" }

      context "Updated Sell in Date" do
        it { expect(update_quality([item])[0][:sell_in]).to eq(initial_sell_in-1) }
      end

      context "Sell Date: more than 10 days" do
        let(:initial_sell_in) { 11 }

        context "Updated Quality" do
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality+1) }
        end

        context "Max quality" do
          let(:initial_quality) { 50 }
        end
      end

      context "Sell Date: 10 days or less" do
        let(:initial_sell_in) { 8 }

        context "Updated Quality" do
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality+2) }
        end

        context "Maximum quality" do
          let(:initial_quality) { 50 }
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality) }
        end
      end

      context "Sell Date: 5 days or less" do
        let(:initial_sell_in) { 4 }

        context "Updated Quality" do
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality+3) }
        end
        
        context "Maximum quality" do
          let(:initial_quality) { 50 }
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality) }
        end
      end

      context "On item sell date" do
        let(:initial_sell_in) { 0 }
        it { expect(update_quality([item])[0][:quality]).to eq(0) }
      end

      context "After item sell date" do
        let(:initial_sell_in) { -4 }
        it { expect(update_quality([item])[0][:quality]).to eq(0) }
      end
    end

    context "For Conjured Item" do
      let(:name) { "Conjured One" }

      context "Updated Sell in date" do
        it { expect(update_quality([item])[0][:sell_in]).to eq(initial_sell_in-1) }
      end

      context "before the sell date" do
        let(:initial_sell_in) { 5 }
        it { expect(update_quality([item])[0][:quality]).to eq(initial_quality-2) }

        context "Zero quality" do
          let(:initial_quality) { 0 }
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality) }
        end
      end

      context "On item sell date" do
        let(:initial_sell_in) { 0 }
        it { expect(update_quality([item])[0][:quality]).to eq(initial_quality-4) }

        context "Zero quality" do
          let(:initial_quality) { 0 }
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality) }
        end
      end

      context "After item sell date" do
        let(:initial_sell_in) { -10 }
        it { expect(update_quality([item])[0][:quality]).to eq(initial_quality-4) }

        context "Zero Quality" do
          let(:initial_quality) { 0 }
          it { expect(update_quality([item])[0][:quality]).to eq(initial_quality) }
        end
      end
    end
  end

  context "with several objects" do
    let(:items) {
      [
        {name: "NORMAL ITEM", sell_in: 5, quality: 10},
        {name: "Aged Brie", sell_in: 3, quality: 10},
      ]
    }

    it { expect(update_quality(items)[0][:quality]).to eq(9) }
    it { expect(update_quality(items)[0][:sell_in]).to eq(4) }

    it { expect(update_quality(items)[1][:quality]).to eq(11) }
    it { expect(update_quality(items)[1][:sell_in]).to eq(2) }
  end
end
