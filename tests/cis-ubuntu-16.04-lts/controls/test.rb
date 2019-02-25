# encoding: utf-8
# copyright: 2018, The Authors

title 'sample section'

include_controls 'cis-dil-benchmark' do
  # skip_control 'cis-dil-benchmark-1.1.1.1'
  # skip_control 'cis-dil-benchmark-1.1.1.2'
  # skip_control 'cis-dil-benchmark-1.1.1.3'
  # skip_control 'cis-dil-benchmark-1.1.1.4'

  control 'cis-dil-benchmark-1.7.1.1' do
    impact 0.3
  end
end