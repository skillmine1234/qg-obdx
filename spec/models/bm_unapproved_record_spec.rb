require 'spec_helper'
describe BmUnapprovedRecord do
  context 'association' do
    it { should belong_to(:bm_approvable) }
  end
end
