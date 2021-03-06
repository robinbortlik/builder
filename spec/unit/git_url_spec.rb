require "spec_helper"
require "git_url"

describe GitUrl do
  subject { described_class.new(url) }

  context "ssh url" do
    let(:url) { "git@github.com:reevoo/awesome_project.git" }

    it "extracts a cache path" do
      expect(subject.cache_path).to eq "/tmp/assemblyline/git_cache/github.com/reevoo/awesome_project.git"
    end

    it "extracts the repo" do
      expect(subject.repo).to eq "reevoo/awesome_project"
    end

    context "github url" do
      specify { expect(subject).to be_github }
    end

    context "not a github url" do
      let(:url) { "git@a10e.org:errm/killer_app.git" }

      specify { expect(subject).to_not be_github }
    end
  end

  context "https url" do
    let(:url) { "https://github.com/assemblyline/shipping_agent.git" }

    it "extracts a cache path" do
      expect(subject.cache_path).to eq "/tmp/assemblyline/git_cache/github.com/assemblyline/shipping_agent.git"
    end

    it "extracts the repo" do
      expect(subject.repo).to eq "assemblyline/shipping_agent"
    end

    context "github url" do
      specify { expect(subject).to be_github }
    end

    context "not a github url" do
      let(:url) { "https://a10e.org/errm/killer_app.git" }

      specify { expect(subject).to_not be_github }
    end
  end


  context "invalid url" do
    let(:url) { "https://twitter.com/assemblyline/shipping_agent" }

    it "raises an appropriate error" do
      expect { subject }.to raise_error "repo url must be valid"
    end
  end
end
