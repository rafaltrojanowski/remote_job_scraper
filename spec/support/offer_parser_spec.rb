require 'spec_helper'

RSpec.describe Support::OfferParser do

  let(:exampe_1) {
"""
If working with a sophisticated cloud environment spanning multiple service providers and acting in a cross-functional role is what youre aiming for, then wed be happy to welcome you to our team as Django / Python Developer for Divio's products! Start date: according to mutual agreement Location: Sweden, Germany or Switzerland Divio is driving Django adoption by putting it in the hands of thousands of developers and users across the world, through the Divio platform and the open-source django CMS. The Divio platform includes Django optimised hosting, developers tools and project templates to enable agencies, enterprises and developers to build scalable and lightning fast Django applications. At Divio we enjoy technology and love working with Python, Django, Ansible, Docker,
"""
  }

  let(:exampe_2) {
"""
Software Development Engineer in Test (SDET)

Location: Remote (WFH) or Arlington, VA (Rosslyn) Thermopylae Sciences and Technology, a fast-paced technology company focused on delivering innovative software solutions to customers across private and public sectors, is looking for a Software Development Engineer in Test to join our awesome development team.     We are looking for a sharp, bright, and proactive individual who can help enable our teams to coordinate and prioritize activities that enhance software quality with a focus on automation and coverage.   TST Products http://www.t-sciences.com/products   Google Earth Enterprise Open Source http://www.opengee.org/   GitHub Site https://github.com/google/earthenterprise/
"""
  }

  let(:exampe_3) {
"""
Software Development Engineer in Test (SDET)
"""
  }

  describe 'get_location' do
    context 'example 1' do
      it 'returns location' do
        expect(Support::OfferParser.get_location(exampe_1)).to eq("Sweden")
      end
    end

    context 'example 2' do
      it 'returns location' do
        expect(Support::OfferParser.get_location(exampe_2)).to eq("Remote")
      end
    end

    context 'example 3' do
      it 'returns nil' do
        expect(Support::OfferParser.get_location(exampe_3)).to be_nil
      end
    end
  end
end
