require File.expand_path('../spec_helper',__FILE__)

describe NagiosAnalyzer::Status do
  before(:each) do
    @file = File.expand_path('../data/status.dat',__FILE__)
    @status = NagiosAnalyzer::Status.new(@file)
  end

  it "creates a NagiosAnalyzer::Status object" do
    @status.should be
    @status.sections.should be_a(Array)
    @status.sections.first.should include("created=")
    @status.should have(6).sections
  end

  it "provides a last_updated attribute" do
    @status.last_updated.should be_a(Time)
  end

  context "#scopes" do
    it "provides scopes to filter sections" do
      @status.should have(6).sections
      @status.should have(0).scopes
    end

    it "tells if a section is in the scopes" do
      @status.scopes << lambda{|s|s.include?("host_name=server-web")}
      @status.in_scope?(@status.sections[2]).should be_true
      @status.in_scope?(@status.sections[3]).should be_false
    end
  end

  context "#items, #service_items, #host_items" do
    it "returns all items" do
      @status.should have(6).sections
      @status.should have(4).items         #don't return info{} and programstatus{} sections
    end

    it "returns host items" do
      @status.should have(2).host_items    #4 = 2 host_items
      @status.host_items.first.should include("hoststatus")
    end

    it "returns service items" do
      @status.should have(2).service_items # ... + 2 service_items
      @status.service_items.first.should include("servicestatus")
    end
  end
end
